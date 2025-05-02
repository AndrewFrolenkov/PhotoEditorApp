//
//  DrawingScreen.swift
//  PhotoEditor
//
//  Created by Андрей Фроленков on 2.05.25.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @EnvironmentObject var model: DrawingViewModel
    
    @State private var scale: CGFloat = 1.0
    @State private var angle = Angle(degrees: 0.0)
    
    var zoom: some Gesture {
        
        MagnificationGesture()
            .onChanged { value in
                
                if value != 0.0 {
                    scale = value.magnitude
                }
                
            }
    }
    
    var rotate: some Gesture {
        RotateGesture()
            .onChanged { value in
                angle = value.rotation
            }
    }
    
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let size = proxy.frame(in: .global)
                
                ZStack {
                    CanvasView(canvas: $model.canvas, toolPicker: $model.toolPicker, imageData: $model.imageData, rect: size.size)
                    
                    ForEach(model.textBoxes) { box in
                        Text(model.textBoxes[model.currentIndex].id == box.id && model.addNewBox ? "" : box.text)
                            .font(.system(size: 30))
                            .fontWeight(box.isBold ? .bold : .none)
                            .foregroundStyle(box.textColor)
                            .offset(box.offset)
                        
                            .gesture(DragGesture().onChanged({ value in
                                let current = value.translation
                                
                                let lastOffset = box.lastOffset
                                
                                let newTranslation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)
                                
                                model.textBoxes[getIndex(textBox: box)].offset = newTranslation
                            }).onEnded({ value in
                                let index = getIndex(textBox: box)
                                model.textBoxes[index].lastOffset = model.textBoxes[index].offset
                            }))
                            .onLongPressGesture {
                                
                                model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                                model.canvas.resignFirstResponder()
                                model.currentIndex = getIndex(textBox: box)
                                
                                withAnimation {
                                    model.addNewBox = true
                                }
                            }
                        
                    }
                }
                .scaleEffect(scale, anchor: .center)
                .rotationEffect(angle, anchor: .center)
                .gesture(
                    zoom.simultaneously(with: rotate)
                )
                
                .onAppear {
                    
                    if model.rect == .zero {
                        model.rect = size
                    }
                }
            }
        }
        
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    model.saveImage()
                } label: {
                    Text("Save")
                }
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                    model.textBoxes.append(TextBox())
                    
                    model.currentIndex = model.textBoxes.count - 1
                    
                    withAnimation {
                        model.addNewBox.toggle()
                    }
                    
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    func getIndex(textBox: TextBox) -> Int {
        let index = model.textBoxes.firstIndex { box in
            return textBox.id == box.id
        } ?? 0
        
        return index
    }
    
    func resetEffect() {
        scale = 1.0
    }
}

struct CanvasView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    @Binding var imageData: Data
    
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = true
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
            
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }
        
        return canvas
    }
    
    func updateUIView(_ uiViewL: PKCanvasView, context: Context) {
        
    }
    
}

#Preview {
    DrawingScreen()
}

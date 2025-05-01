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
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let size = proxy.size
               
                ZStack {
                    CanvasView(canvas: $model.canvas, toolPicker: $model.toolPicker, imageData: $model.imageData, rect: size)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Text("Save")
                }

            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "plus")
            }
        }
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

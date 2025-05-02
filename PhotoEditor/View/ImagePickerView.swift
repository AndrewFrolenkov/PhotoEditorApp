//
//  MainView.swift
//  PhotoEditor
//
//  Created by Андрей Фроленков on 1.05.25.
//

import Foundation
import SwiftUI

import SwiftUI

struct ImagePickerView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @StateObject var model = DrawingViewModel()
    @State private var image = UIImage()
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if let _ = UIImage(data: model.imageData) {
                        DrawingScreen().environmentObject(model)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        model.cancelImageEditing()
                                    } label: {
                                        Image(systemName: "xmark")
                                    }
                                }
                            }
                    } else {
                        HStack(spacing: 20) {
                            Button(action: {
                                model.isImagePickerPresented.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "photo")
                                    Text("Фотолента")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                            
                            Button(action: {
                                model.isCameraPickerPresented.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "camera")
                                    Text("Камера")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Image Editor")
                .navigationBarItems(trailing: Button(action: {
                    viewModel.signOut()
                }) {
                    Text("Выход")
                        .foregroundColor(.red)
                })
            }
            
            if model.addNewBox {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                TextField("Type Here", text: $model.textBoxes[model.currentIndex].text)
                    .font(.system(size: 35, weight: model.textBoxes[model.currentIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundStyle(model.textBoxes[model.currentIndex].textColor)
                    .padding()
                
                HStack {
                    
                    Button {
                        model.textBoxes[model.currentIndex].isAdded = true
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.canvas.becomeFirstResponder()
                        
                        withAnimation {
                            model.addNewBox = false
                        }
                    } label: {
                        Text("Add")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        model.cancelTextView()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    }
                    
                }
                .overlay(
                    HStack(spacing: 15, content: {
                        ColorPicker("", selection: $model.textBoxes[model.currentIndex].textColor)
                            .labelsHidden()
                        
                        Button {
                            model.textBoxes[model.currentIndex].isBold.toggle()
                        } label: {
                            Text(model.textBoxes[model.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }

                    })
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .sheet(isPresented: $model.isImagePickerPresented) {
            ImagePicker(selectedImage: $model.imageData, sourceType: .photoLibrary)
        }
        .fullScreenCover(isPresented: $model.isCameraPickerPresented) {
            ImagePicker(selectedImage: $model.imageData, sourceType: .camera)
        }
        .alert(isPresented: $model.showAlert) {
            Alert(title: Text("Message"), message: Text(model.message), dismissButton: .destructive(Text("Ok")))
        }
        
        
    }
}

#Preview {
    ImagePickerView()
}

//
//  MainView.swift
//  PhotoEditor
//
//  Created by Андрей Фроленков on 1.05.25.
//

import Foundation
import SwiftUI

struct ImagePickerView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @StateObject var model = DrawingViewModel()
    //    @State private var isImagePickerPresented = false
    @State private var isCameraPickerPresented = false
    @State private var image = UIImage()
    
    var body: some View {
        VStack {
            if let imageFile = UIImage(data: model.imageData) {
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
        .sheet(isPresented: $model.isImagePickerPresented) {
            ImagePicker(selectedImage: $model.imageData, sourceType: .photoLibrary)
        }
        .fullScreenCover(isPresented: $model.isCameraPickerPresented) {
            ImagePicker(selectedImage: $model.imageData, sourceType: .camera)
        }
        .navigationTitle("Image Editor")
        .navigationBarItems(trailing: Button(action: {
            viewModel.signOut()
        }) {
            Text("Выход")
                .foregroundColor(.red)
        })
    }
}

#Preview {
    ImagePickerView()
}

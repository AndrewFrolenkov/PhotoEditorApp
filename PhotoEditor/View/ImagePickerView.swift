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
    @State private var isImagePickerPresented = false
    @State private var isCameraPickerPresented = false
    @State private var image = UIImage()
    
    var body: some View {
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 20) {
                Button(action: {
                    self.isImagePickerPresented = true
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
                    self.isCameraPickerPresented = true
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
        .sheet(isPresented: $isImagePickerPresented) {
                   ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
               }
        .fullScreenCover(isPresented: $isCameraPickerPresented) {
            ImagePicker(selectedImage: $image, sourceType: .camera)
        }
        .navigationBarTitle("Фото Редактор", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        // Здесь добавь логику выхода из аккаунта
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

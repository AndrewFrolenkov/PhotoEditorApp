//
//  ForgotPasswordView.swift
//  PhotoEditor
//
//  Created by Андрей Фроленков on 1.05.25.
//
import SwiftUI
import Foundation
import Combine

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AppViewModel
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            Text("Забыли пароль?")
                .font(.title)
            CustomTextField(text: $email, placeholder: "Email", icon: "envelope")
            
            Button("Сбросить пароль") {
                viewModel.resetPassword(email: email)
            }
        }
        .padding()
        .onAppear {
            viewModel.passwordResetResult
                .sink { message in
                    alertMessage = message
                    showAlert = true
                }
                .store(in: &cancellables)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Сброс пароля"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("ОК")) {
                    dismiss()
            })
        }
        Spacer()
    }
    
    
}


import SwiftUI
import Foundation
import Combine

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AppViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Создать аккаунт")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Начните использовать приложение")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 60)
            
            VStack(spacing: 20) {
                CustomTextField(text: $email, placeholder: "Email", icon: "envelope")
                CustomTextField(text: $password, placeholder: "Пароль", icon: "lock", isSecure: true)
            }
            .padding(.horizontal, 30)
            .padding(.top, 40)
            
            Button {
                guard !email.isEmpty, !password.isEmpty else {
                    return
                }
                
                viewModel.signUp(email: email, password: password)
                
            } label: {
                ZStack {
                    Text("Зарегестрироваться")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.signUpResult
                .sink { message in
                    alertMessage = message
                    showAlert = true
                }
                .store(in: &cancellables)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Регистрация"),
                message: Text(alertMessage),
                dismissButton: .default(Text("ОК")) {
                    if alertMessage.contains("отправлено") {
                        dismiss()
                        viewModel.signedIn = true 
                    }
                }
            )
        }
    }
}

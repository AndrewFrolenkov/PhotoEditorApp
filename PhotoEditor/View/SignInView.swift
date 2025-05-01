
import SwiftUI
import Foundation

struct SignInView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Войти в аккаунт")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Введите свои данные")
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
            
//            Button(action: { showForgotPassword = true }) {
//                Text("Забыли пароль?")
//                    .foregroundColor(.blue)
//                    .padding(.top, 10)
//            }
            
            Button {
                guard !email.isEmpty, !password.isEmpty else {
                    return
                }
                
                viewModel.signIn(email: email, password: password)
            } label: {
                ZStack {
                    Text("Войти")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            Button {
                Task {
                    do {
                        try await viewModel.signInWithGoogle()
                    } catch AuthenticationError.runtimeError(let errorMessage) {
                        print(errorMessage)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "person.badge.key.fill")
                    Text("Sign in with Google")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(25)
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            NavigationLink("Create Account", destination: SignUpView())
                .padding()
            
            Spacer()
        }
        .padding()
    }
}

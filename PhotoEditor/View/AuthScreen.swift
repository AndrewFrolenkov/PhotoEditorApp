import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showForgotPassword = false
    @State private var err: String = ""
    @State private var showRegister = false
    
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
            
            Button(action: { showForgotPassword = true }) {
                Text("Забыли пароль?")
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }
            
            Button(action: authenticate) {
                ZStack {
                    Text("Войти")
                        .opacity(isLoading ? 0 : 1)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            Button {
                Task {
                    do {
                        try await Authentication().googleOauth()
                    } catch AuthenticationError.runtimeError(let errorMessage) {
                        err = errorMessage
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
            
            Button(action: { showRegister = true }) {
                Text("Создать аккаунт")
                    .foregroundColor(.blue)
                    .padding(.top, 20)
            }
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Сообщение"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert("Восстановление пароля", isPresented: $showForgotPassword) {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            Button("Отправить") {
                resetPassword()
            }
            Button("Отмена", role: .cancel) {}
        } message: {
            Text("Введите email для восстановления пароля")
        }
        .sheet(isPresented: $showRegister) {
            RegisterView()
        }
    }
    
    private func authenticate() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            handleAuthResult(error: error, successMessage: "Вход выполнен успешно!")
        }
    }
    
    private func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                alertMessage = "Инструкции по восстановлению пароля отправлены на email"
                showAlert = true
            }
        }
    }
    
    private func handleAuthResult(error: Error?, successMessage: String) {
        isLoading = false
        if let error = error {
            alertMessage = error.localizedDescription
            showAlert = true
        } else {
            alertMessage = successMessage
            showAlert = true
        }
    }
}

struct AuthScreen: View {
    var body: some View {
        NavigationView {
            LoginView()
        }
    }
}

#Preview {
    AuthScreen()
}

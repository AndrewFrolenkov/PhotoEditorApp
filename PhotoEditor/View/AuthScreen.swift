import SwiftUI
import FirebaseAuth

struct AuthScreen: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var isLoginMode = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Image(systemName: isLoginMode ? "person.crop.circle" : "person.crop.circle.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text(isLoginMode ? "Войти в аккаунт" : "Создать аккаунт")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(isLoginMode ? "Введите свои данные" : "Начните использовать приложение")
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
                
                Button(action: authenticate) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(isLoginMode ? "Войти" : "Зарегистрироваться")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(25)
                .padding(.horizontal, 30)
                .padding(.top, 30)
                .disabled(isLoading)
                
                Button(action: { isLoginMode.toggle() }) {
                    Text(isLoginMode ? "Создать аккаунт" : "Войти")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Сообщение"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func authenticate() {
        isLoading = true
        if isLoginMode {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                handleAuthResult(error: error, successMessage: "Вход выполнен успешно!")
            }
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                handleAuthResult(error: error, successMessage: "Аккаунт успешно создан!")
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
            if !isLoginMode {
                email = ""
                password = ""
            }
        }
    }
}

#Preview {
    AuthScreen()
} 
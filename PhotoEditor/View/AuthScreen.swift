import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct AuthScreen: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var isLoginMode = true
    @State private var showForgotPassword = false
    
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
                
                if isLoginMode {
                    Button(action: { showForgotPassword = true }) {
                        Text("Забыли пароль?")
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                    }
                }
                
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
                
                Button(action: signInWithGoogle) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .font(.system(size: 24))
                        Text("Войти через Google")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                }
                
                Button(action: { isLoginMode.toggle() }) {
                    Text(isLoginMode ? "Создать аккаунт" : "Войти")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }
                
                if Auth.auth().currentUser != nil {
                    Button(action: signOut) {
                        Text("Выйти из аккаунта")
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                // При открытии экрана
                if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        if let error = error {
                            print("Ошибка восстановления сессии: \(error.localizedDescription)")
                        }
                    }
                }
                
                if let user = Auth.auth().currentUser {
                    print("Текущий пользователь: \(user.email ?? "нет email")")
                    print("Провайдер: \(user.providerData.first?.providerID ?? "нет провайдера")")
                } else {
                    print("Пользователь не авторизован")
                }
            }
            .onDisappear {
                // При закрытии экрана
                GIDSignIn.sharedInstance.signOut()
            }
        }
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
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            email = ""
            password = ""
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [self] result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { [self] result, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showAlert = true
                    return
                }
                
                if result?.user != nil {
                    alertMessage = "Вход выполнен успешно"
                    showAlert = true
                }
            }
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

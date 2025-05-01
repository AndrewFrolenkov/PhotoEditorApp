import FirebaseAuth
import Combine

class AppViewModel: ObservableObject {
    
    @Published var signedIn = false
    
    private let errorHandler = AuthErrorHandler()
    
    let passwordResetResult = PassthroughSubject<String, Never>()
    let signUpResult = PassthroughSubject<String, Never>()
    
    let auth = Auth.auth()
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.signUpResult.send(self?.errorHandler.handleSignInError(error) ?? "Неизвестная ошибка")
                    return
                }
                
                self?.signedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.signUpResult.send(self?.errorHandler.handleSignUpError(error) ?? "Неизвестная ошибка")
                    return
                }
                
                guard let user = result?.user else {
                    self?.signUpResult.send("Не удалось создать пользователя.")
                    return
                }
                
                self?.sendVerificationEmail(for: user)
            }
        }
    }
    
    @MainActor
    func signInWithGoogle() async throws {
        try await AuthenticationForGoogle().googleOauth()
        
        self.signedIn = true
    }
    
    func signOut() {
        try? auth.signOut()
        self.signedIn = false
    }
    
    func resetPassword(email: String) {
        auth.sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.passwordResetResult.send(self?.errorHandler.handlePasswordResetError(error) ?? "Неизвестная ошибка")
                } else {
                    self?.passwordResetResult.send("Ссылка для сброса отправлена на почту.")
                }
            }
        }
    }
    
}

extension AppViewModel {
    
    func sendVerificationEmail(for user: User) {
        user.sendEmailVerification { [weak self] error in
            if let error = error {
                self?.signUpResult.send("Ошибка при отправке письма: \(error.localizedDescription)")
            } else {
                self?.signUpResult.send("Письмо с подтверждением отправлено на почту.")
            }
        }
    }
}

import FirebaseAuth

class AppViewModel: ObservableObject {
    
    @Published var signedIn = false
    
    let auth = Auth.auth()
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
            
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) {  [weak self] result, error in
            guard result != nil, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signInWithGoogle() async throws {
        try await AuthenticationForGoogle().googleOauth()
        signedIn = true
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
    
    
    
    //    private func resetPassword() {
    //        Auth.auth().sendPasswordReset(withEmail: email) { error in
    //            if let error = error {
    //                alertMessage = error.localizedDescription
    //                showAlert = true
    //            } else {
    //                alertMessage = "Инструкции по восстановлению пароля отправлены на email"
    //                showAlert = true
    //            }
    //        }
    //    }
    
}

import SwiftUI
import FirebaseAuth
import Combine

class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    @Published var signedIn = false
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
    
    @MainActor
    func signInWithGoogle() async throws {
        try await AuthenticationForGoogle().googleOauth()
        signedIn = true
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
}

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showForgotPassword = false
    @State private var err: String = ""
    @State private var showRegister = false
    
    var body: some View {
        NavigationStack {
            if viewModel.signedIn {
                Text("You are signed in")
                
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Sign Out")
                        .foregroundStyle(.blue)
                }
                
            } else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
    
    
}

struct SignInView: View {
    @State private var email = ""
    @EnvironmentObject var viewModel: AppViewModel
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
            
            Button {
                guard !email.isEmpty, !password.isEmpty else {
                    return
                }
                
                viewModel.signIn(email: email, password: password)
            } label: {
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
                        try await viewModel.signInWithGoogle()
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
            
            NavigationLink("Create Account", destination: SignUpView())
                .padding()
            
            Spacer()
        }
        .padding()
        
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

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AppViewModel
    @State private var cancellable: AnyCancellable?
    @State private var email = ""
    @State private var password = ""
    
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
                
                cancellable = viewModel.$signedIn
                    .receive(on: DispatchQueue.main)
                    .filter { $0 }
                    .sink { _ in
                        dismiss()
                    }
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
    }
}




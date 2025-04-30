import SwiftUI
import FirebaseCore
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
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
                
                Button(action: authenticate) {
                    ZStack {
                        Text("Зарегистрироваться")
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
                
                Button(action: { dismiss() }) {
                    Text("Войти")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }
                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Сообщение"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarItems(trailing: Button("Закрыть") {
                dismiss()
            })
    }
    
    private func authenticate() {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            handleAuthResult(error: error, successMessage: "Аккаунт успешно создан!")
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
            email = ""
            password = ""
        }
    }
}

#Preview {
    RegisterView()
} 

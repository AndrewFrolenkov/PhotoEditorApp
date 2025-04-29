//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Андрей Фроленков on 29.04.25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var authListener: AuthStateDidChangeListenerHandle?
    
    var body: some View {
        Group {
            if isLoggedIn {
                // Здесь будет основной экран приложения
                VStack {
                    Text("Добро пожаловать!")
                        .font(.largeTitle)
                    
                    Button(action: signOut) {
                        Text("Выйти")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
            } else {
                AuthScreen()
            }
        }
        .onAppear {
            checkAuthState()
        }
        .onDisappear {
            if let listener = authListener {
                Auth.auth().removeStateDidChangeListener(listener)
            }
        }
    }
    
    private func checkAuthState() {
        authListener = Auth.auth().addStateDidChangeListener { auth, user in
            isLoggedIn = user != nil
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Ошибка при выходе: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}

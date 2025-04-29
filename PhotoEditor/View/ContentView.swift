//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Андрей Фроленков on 29.04.25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Добро пожаловать!")
                    .font(.title)
                
                NavigationLink(destination: RegistrationView()) {
                    Text("Регистрация")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}

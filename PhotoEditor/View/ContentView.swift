import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)

    var body: some View {
        VStack {
            if userLoggedIn {
                Home()
            } else {
                AuthScreen()
            }
        }.onAppear{
            //Firebase state change listeneer
           Auth.auth().addStateDidChangeListener { auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI
import FirebaseAuth
import Combine

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            if viewModel.signedIn {
                ImagePickerView()
//                Text("You are signed in")
//                
//                Button {
//                    viewModel.signOut()
//                } label: {
//                    Text("Sign Out")
//                        .foregroundStyle(.blue)
//                }
                
            } else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}








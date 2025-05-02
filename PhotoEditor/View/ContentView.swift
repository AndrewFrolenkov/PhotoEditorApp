import SwiftUI
import FirebaseAuth
import Combine

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        Group {
            if viewModel.signedIn {
                ImagePickerView()
                    .environmentObject(viewModel)
            } else {
                NavigationStack {
                    SignInView()
                }
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

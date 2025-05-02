import SwiftUI
import FirebaseAuth
import Combine

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showEditor = false

    var body: some View {
        ZStack {
            if viewModel.signedIn {
                Color.white // Заглушка подложки
                    .onAppear {
                        showEditor = true
                    }
            } else {
                NavigationStack {
                    SignInView()
                }
            }
        }
        .fullScreenCover(isPresented: $showEditor) {
            ImagePickerView()
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}








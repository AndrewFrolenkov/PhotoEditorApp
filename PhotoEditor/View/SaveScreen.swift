import SwiftUI

struct SaveScreen: View {
    @EnvironmentObject var model: DrawingViewModel

    @State private var isSharing = false
    @State private var image = UIImage()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(uiImage: model.finalPhoto)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                
                HStack(spacing: 20) {
                    // Save button
                    Button(action: model.saveImage) {
                        Text("Save to Photos")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Share button
                    Button(action: {
                        isSharing = true
                    }) {
                        Text("Share")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
        }
        .onAppear {
            
            image = model.finalPhoto
            
        }
        .sheet(isPresented: $isSharing) {
            ActivityViewController(image: image)
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let image: UIImage
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // For iPad: specify the source view to avoid issues with popover
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = context.coordinator.view
            popoverController.sourceRect = CGRect(x: context.coordinator.view.bounds.midX, y: context.coordinator.view.bounds.midY, width: 0, height: 0)
        }
        
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject {
        var view: UIView = UIView()
    }
}

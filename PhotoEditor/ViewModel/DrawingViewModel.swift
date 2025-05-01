

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var isImagePickerPresented = false
    @Published var isCameraPickerPresented = false
    @Published var imageData: Data = Data(count: 0)
    
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    
    func cancelImageEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
    }
}

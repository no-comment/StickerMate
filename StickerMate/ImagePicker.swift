import SwiftUI

struct ImagePicker<Content: View>: View {
    @Binding private var imageData: Data?
    private let content: Content
    
    @State private var takingPicture: Bool = false
    @State private var choosingPhoto: Bool = false
    @State private var importingFile: Bool = false
    
    init(data: Binding<Data?>, @ViewBuilder content: () -> Content) {
        self._imageData = data
        self.content = content()
    }
    
    var body: some View {
        Menu {
            Button {
                self.takingPicture.toggle()
            } label: {
                Label("Camera", systemImage: "camera")
            }
            Button {
                self.choosingPhoto.toggle()
            } label: {
                Label("Photos", systemImage: "photo")
            }
            Button {
                self.importingFile.toggle()
            } label: {
                Label("Files", systemImage: "folder")
            }
        } label: {
            content
        } primaryAction: {
            self.choosingPhoto.toggle()
        }
        .sheet(isPresented: $choosingPhoto) {
            ImageSelector(image: $imageData)
                .edgesIgnoringSafeArea(.bottom)
        }
        .fullScreenCover(isPresented: $takingPicture) {
            ImageSelector(sourceType: .camera, image: $imageData)
                .edgesIgnoringSafeArea(.all)
        }
        .fileImporter(isPresented: $importingFile, allowedContentTypes: [.image]) { result in
            importFileImage(result)
        }
    }
    
    private func importFileImage(_ result: Result<URL, Error>) {
        do {
            let selectedFile: URL = try result.get()
            if selectedFile.startAccessingSecurityScopedResource() {
                if let imageData = try? Data(contentsOf: selectedFile) {
                    self.imageData = imageData
                }
            }
            selectedFile.stopAccessingSecurityScopedResource()
        } catch {
            print("Could not import Image")
            print(error)
        }
    }
}

fileprivate struct ImageSelector: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: Data?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageSelector>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImageSelector>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImageSelector

        init(_ parent: ImageSelector) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = image.pngData()
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(data: .constant(nil)) {
            Text("Test")
        }
    }
}

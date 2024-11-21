//
//  ImagePicker.swift
//  Eventorias
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    enum SourceType {
        case camera
        case photoLibrary
    }
    
    var sourceType: SourceType
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            switch sourceType {
            case .camera:
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    picker.sourceType = .camera
                } else {
                    picker.sourceType = .photoLibrary
                    print("Camera not available, falling back to photo library.")
                }
            case .photoLibrary:
                picker.sourceType = .photoLibrary
            }
            picker.delegate = context.coordinator
            return picker
        }

    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


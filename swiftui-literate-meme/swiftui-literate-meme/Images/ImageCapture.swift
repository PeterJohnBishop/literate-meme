//
//  ImageCapture.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/19/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct accessMediaView: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) var isPresented
    var sourceType: SourceType // Enum for camera or photo library
    
    func makeUIViewController(context: Context) -> UIViewController {
        switch sourceType {
        case .camera:
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = context.coordinator
            return imagePicker
            
        case .photoLibrary:
            var config = PHPickerConfiguration()
            config.filter = .images // Only allow images
            config.selectionLimit = 1 // Allow only one image to be selected
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed here
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

// Enum to specify source type
enum SourceType {
    case camera
    case photoLibrary
}

// Coordinator to handle image selection
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
    var picker: accessMediaView
    
    init(picker: accessMediaView) {
        self.picker = picker
    }
    
    // Handle image selection from UIImagePickerController (Camera)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.picker.selectedImages.append(selectedImage)
        }
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
    // Handle cancellation for UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
    // Handle image selection from PHPickerViewController
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.picker.isPresented.wrappedValue.dismiss()
        
        guard let result = results.first else { return }
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if let uiImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self?.picker.selectedImages.append(uiImage) 
                    }
                }
            }
        }
    }
}

//
//  ImagePicker.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/2/24.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    var imageData: (Data) -> Void
    @Environment(\.presentationMode) var mode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                parent.mode.wrappedValue.dismiss()
                return
            }
            
            parent.imageData(image.imageZipLimit(zipRate: 1)!)
            parent.mode.wrappedValue.dismiss()
        }
    }
}

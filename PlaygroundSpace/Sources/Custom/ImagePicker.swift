//
//  ImagePicker.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/2/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    
    var imageData: ([Data]) -> Void
    @Environment(\.presentationMode) var mode
    var selectedCount: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
       
        if selectedCount == 0 {
            isPresented = false
        }
        
        var config = PHPickerConfiguration()
        config.selectionLimit = selectedCount
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            var imageArray: [UIImage] = []
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { objects, error in
                    DispatchQueue.main.async {
                        guard let image = objects as? UIImage else {
                            dispatchGroup.leave()
                            return
                        }
                        
                        imageArray.append(image)
                        
                        dispatchGroup.leave()
                    }
                }
                
            }
            
            dispatchGroup.notify(queue: .main) { [unowned self] in
                
                parent.imageData(imageArray.compactMap { $0.imageZipLimit(zipRate: 1) })
                parent.isPresented = false
                
            }
        }
        
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
    }
}

//
//  UIImage+Extension.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/2/24.
//

import UIKit

extension UIImage {
    
    func imageZipLimit(zipRate: Double) -> Data? {
        let limitBytes = zipRate * 1024 * 1024
        var currentQuality: CGFloat = 0.7
        var imageData = self.jpegData(compressionQuality: currentQuality)
        
        while let data = imageData,
              Double(imageData!.count) > limitBytes && currentQuality > 0 {
            currentQuality -= 0.1
            imageData = self.jpegData(compressionQuality: currentQuality)
        }
        
        if let data = imageData,
           Double(data.count) <= limitBytes {
            return data
        } else {
            return nil
        }
    }
    
}

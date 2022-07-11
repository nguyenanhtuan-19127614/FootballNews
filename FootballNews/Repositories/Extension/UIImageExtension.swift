//
//  UIImageExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 04/07/2022.
//

import UIKit

extension UIImage {
    
    func createGradientImage(colors: [CGColor], frame: CGRect) -> UIImage? {
        
        let gradient = CAGradientLayer()
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        var updatedFrame = frame
        updatedFrame.size.height += frame.origin.y
        
        gradient.frame = updatedFrame
        gradient.colors = colors;
        
        //Render Gradient Image
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return image
    }
    
    func scale(outputSize: CGSize) -> UIImage {
        
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = outputSize.width / self.size.width
        let heightRatio = outputSize.height / self.size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        //New image size from scaleFactor
        let scaledImageSize = CGSize(width: self.size.width * scaleFactor,
                                    height: self.size.height * scaleFactor)
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

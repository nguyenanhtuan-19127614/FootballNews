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
   
    
}

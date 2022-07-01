//
//  UINavigationBarExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 30/06/2022.
//

import UIKit

extension UINavigationBar {
    
    func setGradientBackground(colors: [CGColor]) {
    
        //Config Gradient Layer
        let gradient = CAGradientLayer()

        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        var updatedFrame = self.frame
        updatedFrame.size.height += self.frame.origin.y
        
        gradient.frame = updatedFrame
        gradient.colors = colors;
        
        //Render Gradient Image
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        //Set Navigation Bar Background
        self.setImageBackground(image: image)

    }
    
    func setImageBackground(image: UIImage?) {
        
        if #available(iOS 13.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundImage = image
            self.scrollEdgeAppearance = navigationBarAppearance
            self.standardAppearance = navigationBarAppearance
        
        } else {
            
            self.setBackgroundImage(image, for: .default)
            
        }
        
    }
    
    
}

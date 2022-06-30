//
//  UINavigationBarExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 30/06/2022.
//

import UIKit

extension UINavigationBar {
    
    func setGradientBackground(colors: [CGColor]) {
    
        let gradient = CAGradientLayer()
    
        gradient.locations = [0.0,0.5,1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        
        var updatedFrame = self.bounds
        updatedFrame.size.height += self.frame.origin.y
        
        gradient.frame = updatedFrame
        gradient.colors = colors;
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
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

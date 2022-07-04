//
//  UINavigationBarExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 30/06/2022.
//

import UIKit

extension UINavigationBar {
    
    func setGradientBackground(colors: [CGColor]) {
    
        //create gradient image
        guard let gradientImage = UIImage().createGradientImage(colors: colors, frame: self.frame) else {
            return
        }
        //Set Navigation Bar Background
        self.setImageBackground(image: gradientImage)

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

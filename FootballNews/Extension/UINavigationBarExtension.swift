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
            //let navigationBarAppearance = UINavigationBarAppearance()
//            navigationBarAppearance.configureWithOpaqueBackground()
//            navigationBarAppearance.backgroundImage = image
//            self.scrollEdgeAppearance = navigationBarAppearance
//            self.standardAppearance = navigationBarAppearance
            self.standardAppearance.configureWithOpaqueBackground()
            self.standardAppearance.backgroundImage = image
            self.scrollEdgeAppearance = self.standardAppearance
            
        
        } else {
            
            self.setBackgroundImage(image, for: .default)
            
        }
        
    }
    
    @available(iOS 13.0, *)
    func createImageBackgroundAppearance(appearance: inout UINavigationBarAppearance, image: UIImage?) {
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundImage = image
        
    }
    

    func setTitleAttribute(color: UIColor, font: UIFont) {
        
        if #available(iOS 13.0, *) {
            
            self.standardAppearance.configureWithOpaqueBackground()
            self.standardAppearance.titleTextAttributes = [.foregroundColor: color,
                                                           .font: font]
            self.scrollEdgeAppearance = standardAppearance
            
        }
        
    }
    
    func setTitleAndGradientBackground(colors: [CGColor], textColor: UIColor, textSize: CGFloat) {
        
        guard let gradientImage = UIImage().createGradientImage(colors: colors, frame: self.frame) else {
            return
        }
        
        if #available(iOS 13.0, *) {
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundImage = gradientImage
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: textColor,
                                                           .font: UIFont.boldSystemFont(ofSize: textSize)]
         
            self.scrollEdgeAppearance = navigationBarAppearance
            self.standardAppearance = navigationBarAppearance
        
        }
        
    }
    
}

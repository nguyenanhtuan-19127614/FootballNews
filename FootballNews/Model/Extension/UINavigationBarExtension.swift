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
    
    @available(iOS 13.0, *)
    func createImageBackgroundAppearance(appearance: inout UINavigationBarAppearance, image: UIImage?) {
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundImage = image
        
    }
    
    @available(iOS 13.0, *)
    func createTitleAttributeAppearance(appearance: inout UINavigationBarAppearance, color: UIColor, font: UIFont) {
        
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: color,
                                          .font: font]
        
    }
    
    func setTitleAndGradientBackground(colors: [CGColor], textColor: UIColor) {
        
        guard let gradientImage = UIImage().createGradientImage(colors: colors, frame: self.frame) else {
            return
        }
        
        if #available(iOS 13.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundImage = gradientImage
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: textColor,
                                                           .font: UIFont.boldSystemFont(ofSize: 20)]
            //navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]

            self.scrollEdgeAppearance = navigationBarAppearance
            self.standardAppearance = navigationBarAppearance
        
        }
        
    }
    
}

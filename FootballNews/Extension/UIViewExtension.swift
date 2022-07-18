//
//  UIViewExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 01/07/2022.
//

import UIKit

extension UIView {
    
    func addShadow(color: CGColor,
                   opacity: Float = 0.5,
                   offset: CGSize = CGSize(width: 0.0, height: -3.0),
                   radius: CGFloat = 3.0) {
        
        self.layer.masksToBounds = false
   
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius

        
    }
   
    func addBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView()
        blurView.center = self.center
        blurView.frame =  self.frame
        self.addSubview(blurView)
        
        UIView.animate(withDuration: 0.3) {
            
            blurView.effect = blurEffect
        }
        
    }
    
    func removeBlurEffect() {
        
        for subview in self.subviews {
            
            if subview is UIVisualEffectView {
                
                subview.removeFromSuperview()
                
            }
        }
      
    }
    
}

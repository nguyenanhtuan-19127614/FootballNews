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
    
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0,
                              y: frame.size.height - borderWidth,
                              width: frame.size.width,
                              height: borderWidth)
        
        addSubview(border)
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
    
    func drawUnderlineAnimation(lineColor: UIColor?, lineWidth: CGFloat, duration: TimeInterval) {
        
        //check if underlined
        for subView in self.subviews {
            if subView.layer.name == "Underline" {
                return
            }
        }
        
        //set up start underline
        let underline = UIView()
        underline.backgroundColor = lineColor ?? UIColor.black
        //middle view
        underline.frame = CGRect(x: self.frame.width/2, y: self.frame.maxY - lineWidth, width: 1, height: lineWidth)
        //layer view
        underline.layer.name = "Underline"
        self.addSubview(underline)
        
        //animate
        UIView.animate(withDuration: duration, delay: 0, options: .layoutSubviews, animations: {
            
            underline.frame.origin.x = 0
            underline.frame.size.width = self.frame.width
            
        })
    
    }
    
    func removeUnderline() {
        
        for subView in self.subviews {
            if subView.layer.name == "Underline" {
                subView.removeFromSuperview()
            }
        }
        
    }
    
}

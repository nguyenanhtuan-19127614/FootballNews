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
    
    func drawUnderlineAnimation(lineColor: CGColor?, lineWidth: CGFloat, duration: CFTimeInterval) {
        
        
        //path
        let path = UIBezierPath()

        path.move(to: CGPoint(x: 0, y: self.frame.maxY))
        path.addLine(to: CGPoint(x: self.frame.maxX - self.frame.minX, y: self.frame.maxY))
        
        //shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "UnderlineShape"
        
        shapeLayer.fillColor = lineColor ?? UIColor.black.cgColor
        shapeLayer.strokeColor = lineColor ?? UIColor.black.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = path.cgPath
        
        //add sublayer
        self.layer.addSublayer(shapeLayer)
        //animate
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = duration
        shapeLayer.add(animation, forKey: "UnderlineAnimation")
    
        
    }
    
    func removeUnderlineAnimation() {
        
        if let sublayers = self.layer.sublayers {
            
            for sublayer in sublayers {
                
                if sublayer.name == "UnderlineShape" {
                    
                    sublayer.removeFromSuperlayer()
                    
                }
                
            }
            
        }
       
    }
    
    
    
}

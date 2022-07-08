//
//  PaddingLabel.swift
//  FootballNews
//
//  Created by LAP13606 on 08/07/2022.
//

import UIKit

class PaddingLabel: UILabel {
    
    var topPadding: CGFloat = 0
    var bottomPadding: CGFloat = 0
    var leftPadding: CGFloat = 0
    var rightPadding: CGFloat = 0
    
    func setupPadding(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        
        self.topPadding = top
        self.bottomPadding = bottom
        self.leftPadding = left
        self.rightPadding = right
        
    }
    
    override func drawText(in rect: CGRect) {
        
        let insets = UIEdgeInsets(top: topPadding,
                                  left: leftPadding,
                                  bottom: bottomPadding,
                                  right: rightPadding)
        super.drawText(in: rect.inset(by: insets))
        
    }
    
    override var intrinsicContentSize: CGSize {
        
           let size = super.intrinsicContentSize
           return CGSize(width: size.width + leftPadding + rightPadding,
                         height: size.height + topPadding + bottomPadding)
        
    }
    
}

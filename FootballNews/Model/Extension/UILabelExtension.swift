//
//  UILabelExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 22/06/2022.
//

import Foundation
import UIKit

extension UILabel {
    
    func calculateHeight(cellWidth: CGFloat) -> CGFloat {
        
        let label = UILabel()
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: cellWidth,
                             height: 0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        
        return label.frame.height
        
    }
    
    func calculateWidth(cellHeight: CGFloat) -> CGFloat {
        
        let label = UILabel()
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: 0,
                             height: cellHeight)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        
        return label.frame.width
        
    }
}

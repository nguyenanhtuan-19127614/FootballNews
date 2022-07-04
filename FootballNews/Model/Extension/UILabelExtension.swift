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
    
    func renderHTMLAtribute(from string: String, size: CGFloat = 0) {
        
        if let attributeString = string.renderHTMLAttribute() {
            
            self.attributedText = attributeString
           
            
        } else {
            
            self.text = string
           
        }
        
        if size != 0 {
            
            self.font = self.font.withSize(size)
            
        }
    
    }
    
    func compareDatewithToday(date: Date) {
 
        let diff = Date().compareWithToday(date: date)
       
        if let year = diff.year,
           let month = diff.month,
           let day = diff.day,
           let hour = diff.hour,
           let minute = diff.minute {
            
            if year <= 0 && month <= 0 {
                
                if day > 0 && day <= 7 {
                    
                    self.text = "\(day) Ngày"
                    
                } else if hour > 0 {
                    
                    if minute < 0 && hour == 1{
                        
                        self.text = "\(60 + minute) Phút"
                        
                    } else if minute < 0 && hour > 1 {
                        
                        self.text = "\(hour - 1) Giờ"
                        
                    } else {
                        
                        self.text = "\(hour) Giờ"
                        
                    }
  
                } else if minute > 0 {
                    
                    self.text = "\(minute) Phút"
                    
                } else {
                    
                    self.text = "Mới Đây"
                    
                }
                
            } else {
                
                self.text = Date().dateToString(date)
                
            }
            
        }

    }
}

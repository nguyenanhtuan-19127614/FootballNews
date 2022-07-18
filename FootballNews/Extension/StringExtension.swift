//
//  StringExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 22/06/2022.
//

import Foundation
import UIKit
extension String {
    
    func renderHTMLAttribute(lineSpacing: CGFloat) -> NSMutableAttributedString? {
        
        guard let data = NSString(string: self).data(using: String.Encoding.unicode.rawValue) else {
            return nil
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
        
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.unicode.rawValue,
            
        ]
  
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        //render html
        if let attributedString = try? NSMutableAttributedString(data: data,
                                                                 options: attributedOptions,
                                                                 documentAttributes: nil) {
            //line spacing
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            return attributedString
            
        } else {
            
            return nil
            
        }
    }
    
    
}

//
//  StringExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 22/06/2022.
//

import Foundation

extension String {
    
    func renderHTMLAttribute() -> NSAttributedString? {
        
        
        let data = NSString(string: self).data(using: String.Encoding.unicode.rawValue)
        
        if let attributedString = try? NSAttributedString(data: data!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {

            return attributedString
            
        } else {
            
            return nil
            
        }
    }
    
    
}

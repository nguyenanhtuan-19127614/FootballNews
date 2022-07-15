//
//  StringExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 22/06/2022.
//

import Foundation

extension String {
    
    func renderHTMLAttribute() -> NSAttributedString? {
        
        guard let data = NSString(string: self).data(using: String.Encoding.unicode.rawValue) else {
            return nil
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
        
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.unicode.rawValue
            
        ]
        
         if let attributedString = try? NSAttributedString(data: data,
                                                           options: attributedOptions,
                                                           documentAttributes: nil) {

            return attributedString
            
        } else {
            
            return nil
            
        }
    }
    
    
}

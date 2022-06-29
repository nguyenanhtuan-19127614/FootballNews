//
//  ArrayExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 29/06/2022.
//

import Foundation

extension Array where Element: Hashable{
    
    mutating func addHead(_ value: Element) {

        self.insert(value, at: 0)
        
    }
    
    mutating func moveToHead(_ value: Element){
        
        for (index, object) in self.enumerated() {
            
            if value == object {
                
                self.remove(at: index)
                self.addHead(value)
            }
            
        }
        
    }
    
}

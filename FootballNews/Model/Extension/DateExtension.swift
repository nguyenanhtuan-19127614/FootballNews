//
//  DateExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 17/06/2022.
//

import Foundation

extension Date {
    
    func getTodayComponent(_ component: Calendar.Component)-> String {
        
        let calendar = Calendar.current
        let component = calendar.component(component, from: self)
        
        if component < 10 {
            
            return "0\(component)"
        }
        
        return String(component)
        
    }
    
    func getTodayAPIQueryString() -> String {
        


        let year = Date().getTodayComponent(.year)
        let month = Date().getTodayComponent(.month)
        let day = Date().getTodayComponent(.day)
    
        return "\(year)\(month)\(day)"
        
    }
}

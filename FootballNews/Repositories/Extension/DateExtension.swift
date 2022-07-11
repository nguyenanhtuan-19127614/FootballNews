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
    
    func timestampToDate(_ timestamp: String) -> Date? {
        
        var timestamp = timestamp
        if(timestamp.count > 10) {
            
            timestamp.insert(".", at: timestamp.index(timestamp.startIndex, offsetBy: 10))
          
        }
        
        if let unixTimestamp = Double(timestamp) {
            
            let date = Date(timeIntervalSince1970: unixTimestamp)
            
            return date
            
        }
        
        return nil
        
    }
    
    func dateToString(_ date: Date?, fullDate: Bool = false) -> String {
        
        guard let date = date else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        if let localTimeZoneAbbreviation = TimeZone.current.abbreviation() {
            
            dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
            
        } else {
            
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            
        }
        
        dateFormatter.locale = Locale.current
        
        if fullDate {
            
            dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
            
        } else {
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
        }
      
        return dateFormatter.string(from: date)
        
    }
    
    func compareWithToday(date: Date) -> DateComponents {
        
        let now = Date()
        let calendar = Calendar.current
        
        var resultDiff = DateComponents()
        
        resultDiff.year = calendar.component(.year, from: now) - calendar.component(.year, from: date)
        resultDiff.month = calendar.component(.month, from: now) - calendar.component(.month, from: date)
        resultDiff.day = calendar.component(.day, from: now) - calendar.component(.day, from: date)
        resultDiff.hour = calendar.component(.hour, from: now) - calendar.component(.hour, from: date)
        resultDiff.minute = calendar.component(.minute, from: now) - calendar.component(.minute, from: date)

        return resultDiff
        
    }
}

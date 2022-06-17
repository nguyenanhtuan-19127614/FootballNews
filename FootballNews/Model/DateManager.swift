//
//  DateManager.swift
//  FootballNews
//
//  Created by LAP13606 on 17/06/2022.
//

import Foundation

class DateManager {
    
    static var shared = DateManager()
    private init(){}
    
    //let dateFormatter = DateFormatter()
    
    func compareWithToday() {
        
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
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale.current
        
        if fullDate {
            
            dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
            
        } else {
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
        }
      
        return dateFormatter.string(from: date)
        
    }
    
}

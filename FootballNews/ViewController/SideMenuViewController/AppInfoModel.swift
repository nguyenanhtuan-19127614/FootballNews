//
//  AppInfoModel.swift
//  FootballNews
//
//  Created by LAP13606 on 16/07/2022.
//

import Foundation

enum AppInfo {
    
    case version
    case email
    case phone
    
    func getValue() -> String{
        
        switch self {
            
        case .version:
            return "1.0"
            
        case .email:
            return "abc@gmail.com"
            
        case .phone:
            return "0975682017"
            
        }
        
    }
}

//
//  ResponseStructure.swift
//  FootballNews
//
//  Created by LAP13606 on 12/06/2022.
//

import Foundation

// MARK: - QueryTeam
struct ResponseModel<T: Codable>: Codable {
    
    let data: T
    let errorCode: Int
    let errorMessage: String
        
    enum CodingKeys: String, CodingKey {
        
        case data
        case errorCode = "error_code"
        case errorMessage = "error_message"
        
    }
    
}


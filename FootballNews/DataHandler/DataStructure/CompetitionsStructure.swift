//
//  CompetitionsStructure.swift
//  FootballNews
//
//  Created by LAP13606 on 13/06/2022.
//

import Foundation

// MARK: - DataClass [Contents]
struct CompetitionData: Codable {
    
    let contents: [Contents]
    let boxes: [Box]
    
    enum CodingKeys: String, CodingKey {
        
        case contents
        case boxes
    }
    
}

//
//  ArticleDetailModel.swift
//  FootballNews
//
//  Created by LAP13606 on 11/07/2022.
//

import Foundation

struct ArticelDetailModel: Codable {
    
    var title: String
    var date: Int
    var description: String
    
    var source: String
    var sourceLogo: String
    var sourceIcon: String
    
    var body: [Body]?
    
}

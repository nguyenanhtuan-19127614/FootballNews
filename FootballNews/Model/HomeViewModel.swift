//
//  HomeViewModel.swift
//  FootballNews
//
//  Created by LAP13606 on 11/07/2022.
//

import Foundation

//Data for Listing Articel

struct HomeArticleModel: Codable {
    
    var contentID: String
    var title: String
    var description: String
    var avatar: String

    var source: String
    var publisherLogo: String
    var publisherIcon: String
    
    var date: Int

}

//Data for Score Board
struct HomeScoreBoardModel {
    
    var matchID: Int
    
    var status: Int
    var competition: String
    var competitionID: Int
    
    var time: String
    var startTime: String
    
    var homeID: Int
    var homeLogo: String
    var homeName: String
    var homeScore: Int
    
    var awayID: Int
    var awayLogo: String
    var awayName: String
    var awayScore: Int
    
}

//Data for Competition Board
struct HomeCompetitionModel {
    
    var id: Int
    var logo: String
    var name: String
    
}

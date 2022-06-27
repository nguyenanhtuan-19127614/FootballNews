//
//  HomeDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import Foundation

//Data for Listing Articel
struct HomeArticleData {
    
    var contentID: String
    var avatar: String
    var title: String
    var author: String
    var link: String
  
}

//Data for Score Board
struct HomeScoreBoardData {
    
    var status: Int
    var competition: String
    var time: String
    
    var homeLogo: String
    var homeName: String
    var homeScore: Int
    
    var awayLogo: String
    var awayName: String
    var awayScore: Int
    
}

//Data for Competition Board
struct HomeCompetitionData {
    
    var logo: String
    var name: String
    
}

class HomeDataSource {
    
    
    var articelSize = 0
    var scoreBoardSize = 0
    var competitionSize = 0
    
    var articleData: [HomeArticleData] = [] {
        
        didSet {
            
            articelSize = articleData.count
        
            NotificationCenter.default.post(name: NSNotification.Name("ReloadHomeView"), object: nil)
           
        }

    }
    
    var scoreBoardData: [HomeScoreBoardData] = [] {
        
        didSet {
            
            scoreBoardSize = scoreBoardData.count
            NotificationCenter.default.post(name: NSNotification.Name("ReloadHomeView"), object: nil)
       
        }
        
    }
    
    var competitionData: [HomeCompetitionData] = [] {
        
        didSet {
            
            competitionSize = competitionData.count
            NotificationCenter.default.post(name: NSNotification.Name("ReloadHomeView"), object: nil)
     
        }
        
    }
    
}

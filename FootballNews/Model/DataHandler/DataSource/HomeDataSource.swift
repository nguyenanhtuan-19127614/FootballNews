//
//  HomeDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import Foundation

//Data for Listing Articel

struct HomeArticleModel {
    
    var contentID: String
    var avatar: String
    var title: String
    var author: String
    var link: String
    var date: Int
    
}

//Data for Score Board
struct HomeScoreBoardModel {
    
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
struct HomeCompetitionModel {
    
    var logo: String
    var name: String
    
}

class HomeDataSource {

    weak var delegate: DataSoureDelegate?
    
    var lock = NSLock()
    
    var articelSize = 0
    var scoreBoardSize = 0
    var competitionSize = 0
    
    var apiNumbers = 3
    var apiLoadedCount = 0 {
        
        didSet {
            
            if apiLoadedCount == apiNumbers {
                
                delegate?.reloadData()
                delegate?.stopRefresh()
                
            }
           
        }
    }
    
    
    var cellSize: Int {
        
        get {
        
            return articelSize
            
        }
        
    }
    
    var articleData: [HomeArticleModel] = [] {
        
        willSet {
            
            lock.lock()
            apiLoadedCount += 1
            lock.unlock()
            
        }
        
        didSet {
            
            articelSize = articleData.count
            
        }

    }
    
    var scoreBoardData: [HomeScoreBoardModel] = [] {
        
        willSet {
            
            lock.lock()
            if apiLoadedCount < apiNumbers {
               
               apiLoadedCount += 1
            }
            lock.unlock()
            
        }
        
        didSet {
        
            scoreBoardSize = scoreBoardData.count
            
        }
        
    }
    
    var competitionData: [HomeCompetitionModel] = [] {
        
        willSet {
            
            lock.lock()
            if apiLoadedCount < apiNumbers {
               
               apiLoadedCount += 1
            }
            lock.unlock()
            
        }
        
        didSet {
            
            competitionSize = competitionData.count

        }
        
    }
    
    //Refresh data source
    func refresh() {
        
        articelSize = 0
        scoreBoardSize = 0
        competitionSize = 0
        
        articleData = []
        scoreBoardData = []
        competitionData = []
        
        apiLoadedCount = 0
        self.delegate?.getData()

    }
    
}

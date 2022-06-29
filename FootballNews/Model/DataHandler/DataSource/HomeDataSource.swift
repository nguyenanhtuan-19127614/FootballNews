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
    var date: Int
    
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

    weak var delegate: DataSoureDelegate?
    
    var lock = NSLock()
    
    var articelSize = 0
    var scoreBoardSize = 0
    var competitionSize = 0
    
    var loadedCount = 0
    var apiNumbers = 3
    
    var cellSize: Int {
        
        get {
        
            return articelSize
            
        }
        
    }
    
    var articleData: [HomeArticleData] = [] {
        
        willSet {
            
            lock.lock()
            loadedCount += 1
            lock.unlock()
            
        }
        
        didSet {
            
            articelSize = articleData.count
            
            if loadedCount == apiNumbers {
                
                self.delegate?.reloadData()
                
            }
      
        }

    }
    
    var scoreBoardData: [HomeScoreBoardData] = [] {
        
        willSet {
            
            lock.lock()
            if loadedCount < apiNumbers {
               
               loadedCount += 1
            }
            lock.unlock()
            
        }
        
        didSet {
        
            scoreBoardSize = scoreBoardData.count
            
            if loadedCount == apiNumbers  {
                
                self.delegate?.reloadData()
                
            }
            
        }
        
    }
    
    var competitionData: [HomeCompetitionData] = [] {
        
        willSet {
            
            lock.lock()
            if loadedCount < apiNumbers {
               
               loadedCount += 1
            }
            lock.unlock()
            
        }
        
        didSet {
            
            competitionSize = competitionData.count
            
            if loadedCount == apiNumbers {
                
                self.delegate?.reloadData()
                
            }

        }
        
    }
    
}

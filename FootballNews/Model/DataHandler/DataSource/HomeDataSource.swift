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

protocol HomeDataSoureDelegate: AnyObject {
    
    func reloadData()
    
}

class HomeDataSource {

    weak var delegate: HomeDataSoureDelegate?
    
    var lock = NSLock()
    
    var articelSize = 0
    var scoreBoardSize = 0
    var competitionSize = 0
    
    var loadingCount = 0
    var apiNumbers = 3
    
    var articleData: [HomeArticleData] = [] {
        
        willSet {
            
            lock.lock()
            if loadingCount < apiNumbers {
               
               loadingCount += 1
            }
            lock.unlock()
            
        }
        
        didSet {
            
            articelSize = articleData.count
            
            if loadingCount == apiNumbers {
                
                self.delegate?.reloadData()
                
            }
      
        }

    }
    
    var scoreBoardData: [HomeScoreBoardData] = [] {
        
        willSet {
            
            lock.lock()
            if loadingCount < apiNumbers {
               
               loadingCount += 1
            }
            lock.unlock()
            
        }
        
        didSet {
        
            scoreBoardSize = scoreBoardData.count
            
            if loadingCount == apiNumbers  {
                
                self.delegate?.reloadData()
                
            }
            
        }
        
    }
    
    var competitionData: [HomeCompetitionData] = [] {
        
        willSet {
            
            lock.lock()
            if loadingCount < apiNumbers {
               
               loadingCount += 1
            }
            lock.unlock()
            
        }
        
        didSet {
            
            competitionSize = competitionData.count
            
            if loadingCount == apiNumbers {
                
                self.delegate?.reloadData()
                
            }

        }
        
    }
    
}

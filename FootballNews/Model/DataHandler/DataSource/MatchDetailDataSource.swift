//
//  MatchDetailDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 06/07/2022.
//

import Foundation

struct RankingModel {
    
    var teamName: String
    var totalStat: Stats
    var homeStat: Stats
    var awayStat: Stats
    
}

class MatchDetailDataSource {
    
    weak var delegate: DataSoureDelegate?
    
    var lock = NSLock()
    
    var cacheActive = false
    var isVCLoaded = false
    
    var articelSize = 0
    var rankingSize = 0
    
    var apiNumbers = 2
    var apiLoadedCount = 0 {
        
        didSet {
            
            if apiLoadedCount == apiNumbers {
                
                //First loaded when apicount == api numbers
                if !isVCLoaded {
                    //Reload data
                    delegate?.reloadData()
                    isVCLoaded = true
                    
                }
                //Refresh case
                delegate?.stopRefresh()
               
            }
            
        }
        
    }
    
    //Header Info data
    var headerData: HomeScoreBoardModel?
    
    //Articel news data
    var articleData: [HomeArticleModel] = [] {
        
        didSet {
            
            articelSize = articleData.count
            lock.lock()
            apiLoadedCount += 1
            lock.unlock()
            
        }
    }
    
    //Competition ranking data
    var rankingData: [RankingModel] = [] {
        
        didSet {
            
            rankingSize = rankingData.count
            print("rankingData: \(rankingData)")
            lock.lock()
            apiLoadedCount += 1
            lock.unlock()
            
        }
        
        
    }
}

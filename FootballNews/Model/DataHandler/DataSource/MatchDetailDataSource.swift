//
//  MatchDetailDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 06/07/2022.
//

import Foundation

class MatchDetailDataSource {
    
    weak var delegate: DataSoureDelegate?
    
    var lock = NSLock()
    
    var cacheActive = false
    var isVCLoaded = false
    
    var articelSize = 0
    
    var apiNumbers = 1
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
    
    var dataSourceSize: Int {
        
        get {
            
            return articelSize
            
        }
        
    }
    
    var headerData: HomeScoreBoardModel?
    //When articleData are loaded, store it to local
    var articleData: [HomeArticleModel] = [] {
        
        didSet {
            
            articelSize = articleData.count
            lock.lock()
            apiLoadedCount += 1
            lock.unlock()
            
        }
    }
}

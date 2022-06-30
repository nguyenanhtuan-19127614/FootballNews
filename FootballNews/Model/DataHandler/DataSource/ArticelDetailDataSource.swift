//
//  ArticelDetailDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 27/06/2022.
//

import Foundation

struct ArticelDetailModel {
    
    var title: String
    var date: Int
    var description: String
    
    var source: String
    var sourceLogo: String
    var sourceIcon: String
    
    var body: [Body]?
    
}

class ArticelDetailDataSource {
    
    weak var delegate: DataSoureDelegate?
    
    let lock = NSLock()
    
    var contentHeadSize = 0
    var contentBodySize = 0
    var relatedSize = 0
    
    var loadedCount = 0
    var apiNumbers = 1
    
    var dataSourceSize: Int {
        
        get {
            
            return contentHeadSize + contentBodySize + relatedSize
            
        }
        
    }
    
    var detailData: ArticelDetailModel? {
        
        willSet {
            
            lock.lock()
            if loadedCount < apiNumbers {
               
               loadedCount += 1
                
            }
            lock.unlock()
            
        }
        
        didSet {
            
            if let detailBody = detailData?.body  {
                contentBodySize = detailBody.count
            }
            
            contentHeadSize = 1
           
            
            if loadedCount == apiNumbers {
                
                self.delegate?.reloadData()
                
            }
      
        }
        
    }
    var relatedArticleData: [HomeArticleModel] = [] {
       
        didSet {
        
            relatedSize = relatedArticleData.count
            
        }
        
        
    }
    
    
}

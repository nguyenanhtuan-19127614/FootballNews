//
//  ArticelDetailDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 27/06/2022.
//

import Foundation

class ArticelDetailDataSource {
    
    weak var delegate: DataSoureDelegate?
    
    //ViewController State
    var state: ViewControllerState = .loading
    
    //Variable
    var contentID: String = ""
    var publisherLogo: String = ""
    
    
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
    
    //MARK: GET Data Functions
    func getArticelDetailData() {
        
        if state == .offline {
            return
        }
        
        let contentID = self.contentID
      
        QueryService.sharedService.get(ContentAPITarget.detail(contentID: contentID)) {
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                
                guard let content = data.data?.content else {
                    
                    return
                    
                }
                //Load detail data
                let detailData = ArticelDetailModel(title: content.title,
                                                    date: content.date,
                                                    description: content.description,
                                                    source: content.source,
                                                    sourceLogo: content.publisherLogo,
                                                    sourceIcon: content.publisherIcon,
                                                    body: content.body)
                self.detailData = detailData
                
                guard let related = data.data?.related else {
                    
                    return
                    
                }
                
                //Load related contents data
                var articelArray: [HomeArticleModel] = []
                for i in related.contents {
                    
                    articelArray.append(HomeArticleModel(contentID: String(i.contentID),
                                                        avatar: i.avatar,
                                                        title: i.title,
                                                        publisherLogo: i.publisherLogo,
                                                        date: i.date))
                    
                }
                
                self.relatedArticleData.append(contentsOf: articelArray)
                self.state = .loaded
                
            case .failure(let err):
                
                print(err)
                self.state = .error
                
                DispatchQueue.main.async {
                    
                    self.delegate?.reloadData()
                   
                }
                
                
            }
            
            
        }
        
    }
    
}

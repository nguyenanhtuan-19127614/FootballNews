//
//  HomeDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import Foundation

//Data for Listing Articel

struct HomeArticleModel: Codable {
    
    var contentID: String
    var avatar: String
    var title: String
    var publisherLogo: String
    var date: Int
    
}

//Data for Score Board
struct HomeScoreBoardModel {
    
    var matchID: Int
    
    var status: Int
    var competition: String
    var startTime: String
    
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
    
    lazy var diskCache = DiskCache()
    
    var lock = NSLock()
    
    var articelSize = 0
    var scoreBoardSize = 0
    var competitionSize = 0
    
    var cacheActive = false
    var isVCLoaded = false
    
    var apiNumbers = 3
    var apiLoadedCount = 0 {
        
        didSet {
            
            if apiLoadedCount == apiNumbers {
                
                //First loaded when apicount == api numbers
                if !isVCLoaded {
                   
                    //Reload data
                    delegate?.reloadData()
                    //MARK: Start to caching data to disk
                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                        [unowned self] in
                        self.diskCachingData()
                    }
                    //diskCachingData()
                    isVCLoaded = true
                    
                }
                //Refresh case
                delegate?.stopRefresh()
               
            }
            
        }
    }
    
    
    var cellSize: Int {
        
        get {
            
            return articelSize
            
        }
        
    }
    
    //When articleData are loaded, store it to local
    var articleData: [HomeArticleModel] = [] {
        
        didSet {
            
            articelSize = articleData.count
            lock.lock()
            apiLoadedCount += 1
            lock.unlock()
            
        }
    }
    
    var scoreBoardData: [HomeScoreBoardModel] = [] {
        
        didSet {
            
            scoreBoardSize = scoreBoardData.count
            lock.lock()
            if apiLoadedCount < apiNumbers {
                
                apiLoadedCount += 1
                
            }
            lock.unlock()
            
        }
        
    }
    
    var competitionData: [HomeCompetitionModel] = [] {
        
        didSet {
            
            competitionSize = competitionData.count
            lock.lock()
            if apiLoadedCount < apiNumbers {
                
                apiLoadedCount += 1
            }
            lock.unlock()
            
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
    
    //MARK: Disk cache after get first article data
    
    func diskCachingData() {
        
        //Store article Data swift
        if cacheActive == false {
            
            diskCache.removeAllImageFromDisk()
            let concurrentQueue = DispatchQueue(label: "OfflineDownloadQueue", qos: .background, attributes: .concurrent)
            
            concurrentQueue.async {
                
                [unowned self] in
                //Save article Data
                self.diskCache.cacheData(data: self.articleData, key: .homeArticel)
                //Download and cache image to disk
                for data in articleData {
                    
                    let avatar = data.avatar
                    let publisherLogo = data.publisherLogo
                    self.diskCache.downloadAndsaveImageToDisk(url: avatar)
                    self.diskCache.downloadAndsaveImageToDisk(url: publisherLogo)
                }
                
            }
            
           concurrentQueue.async {
                
                [unowned self] in
                var articelDetail: [String: ArticelDetailModel] = [:]
                
                //Save detail article data
                for article in self.articleData {
                    
                    QueryService.sharedService.get(ContentAPITarget.detail(contentID: article.contentID)) {
                        [unowned self]
                        (result: Result<ResponseModel<ContentModel>, Error>) in
                        
                        switch result {
                        case .success(let data):
                            
                            guard let content = data.data?.content else {
                                return
                            }
                            //Save detail data
                            let detailData = ArticelDetailModel(title: content.title,
                                                                date: content.date,
                                                                description: content.description,
                                                                source: content.source,
                                                                sourceLogo: content.publisherLogo,
                                                                sourceIcon: content.publisherIcon,
                                                                body: content.body)
                            self.lock.lock()
                            articelDetail[article.contentID] = detailData
                            self.diskCache.cacheData(data: articelDetail, key: .articelDetail)
                            self.lock.unlock()
                            
                            //Download and cache image to disk
                            if let body = detailData.body {
                                
                                for content in body {
                                    
                                    if content.type != "text" {
                                        
                                        self.diskCache.downloadAndsaveImageToDisk(url: content.content)
                        
                                            
                                    }
                                        
                                }
                                    
                            }

                        case .failure(_):
                            return
                            
                        }
                    }
                }
               
            }
            
            cacheActive = true
            
            
        }
        
    }
    
}


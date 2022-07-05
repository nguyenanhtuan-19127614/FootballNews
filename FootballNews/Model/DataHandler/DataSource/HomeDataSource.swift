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
                
                if !isVCLoaded {
                    print("hihihi")
                   
                    delegate?.reloadData()
                    diskCachingData()
                    isVCLoaded = true
                }
                
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
    
    //MARK: Disk cache after get first article data
    
    func diskCachingData() {
        
        //Store article Data swift
        if cacheActive == false {
            print("size: \(self.articelSize)")
            diskCache.removeAllImageFromDisk()
            DispatchQueue.global(qos: .background).async {
                
                [unowned self] in
                //Save article Data
                self.diskCache.cacheData(data: self.articleData, key: .homeArticel)
                //Download and cache image to disk
                for data in articleData {
                    
                    let avatar = data.avatar
                    ImageDownloader.sharedService.download(url: avatar) {
                        
                        [unowned self]
                        result in
                        switch result {
                            
                        case .success(let image):
                            
                            guard let image = image else {
                                return
                            }
                            self.diskCache.saveImageToDisk(imageName: avatar, image: image)
                            
                            
                        case .failure( _):
                            return
                            
                        }
                    }
                }
                
            }
            
            DispatchQueue.global(qos: .background).async {
                
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
                                        
                                        ImageDownloader.sharedService.download(url: content.content) {
                                            
                                            result in
                                            switch result {
                                                
                                            case .success(let image):
                                                
                                                guard let image = image else {
                                                    return
                                                }
                                                
                                                self.diskCache.saveImageToDisk(imageName: content.content,
                                                                               image: image)
                                                
                                                
                                            case .failure( _):
                                                return
                                                
                                            }
                                            
                                        }
                                        
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


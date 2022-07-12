//
//  HomeDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import Foundation


class HomeDataSource {
    
    weak var delegate: DataSoureDelegate?
    
    lazy var diskCache = DiskCache()
    
    var lock = NSLock()
    
    var articleAPILoaded = false
    var scoreBoardAPILoaded = false
    var competitionAPILoaded = false
    
    var cacheActive = false
    var isVCLoaded = false
    
    //ViewController State
    var state: ViewControllerState = .loading
    
    //ScoreBoard and competition Exist or not
    var scoreBoardExist: Bool = false
    var competitionExist: Bool = false
    
    //Index where score board and competition should be based on articels list
    var scoreBoardIndex = 0
    let competitionIndex = 4
    
    //Location and competiion
    var competitionLocation: Set<Int> = []
    
    //query param
    var startArticel = 0
    var articelLoadSize = 20
    
    
    var apiNumbers = 3
    var apiLoadedCount = 0 {
        
        didSet {
            
            if apiLoadedCount == apiNumbers {
                
                //First loaded when apicount == api numbers
                if !isVCLoaded {
                    
                    //Reload data
                    
                    //MARK: Start to caching data to disk
//                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
//                        
//                        [unowned self] in
//                        
//                        if !articleData.isEmpty {
//                            self.diskCache.diskCachingData(articleData: articleData)
//                        }
//                       
//                      
//                    }
                    
                    isVCLoaded = true
                    
                }
                delegate?.reloadData()
                //Refresh case
                delegate?.stopRefresh()
                
            }
            
        }
    }
    
    
    var cellSize: Int {
        
        get {
            
            return articleData.count + 1
            
        }
        
    }
    
    //When articleData are loaded, store it to local
    var articleData: [HomeArticleModel] = [] {
        
        didSet {

            
            lock.lock()
            apiLoadedCount += 1
            //Load more case
            if apiLoadedCount > apiNumbers && articleData.count != 0 {
                
                self.delegate?.reloadData()
                
            }
            
            lock.unlock()
            
        }
    }
    
    var scoreBoardData: [HomeScoreBoardModel] = [] {
        
        didSet {
        
            lock.lock()
            if !scoreBoardAPILoaded {
                
                apiLoadedCount += 1
                scoreBoardAPILoaded = true
                
            }
            lock.unlock()
            
        }
        
    }
    
    var competitionData: [HomeCompetitionModel] = [] {
        
        didSet {
            
            lock.lock()
            if !competitionAPILoaded {
                
                apiLoadedCount += 1
                
                competitionAPILoaded = true
            }
            lock.unlock()
            
        }
        
    }
    
    
    //MARK: GET Data Functions
    
    //get data home news listing
    func getHomeArticelData() {
        
        QueryService.sharedService.get(ContentAPITarget.home(start: startArticel,
                                                             size: articelLoadSize)) {
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            
            guard let self = self else {
                return
            }
            switch result {
                
            case .success(let res):
                
                
                
                if let contents = res.data?.contents {
                    
                    self.competitionLocation.insert( self.articleData.count + self.competitionIndex)
                    
                    
                    var articelArray: [HomeArticleModel] = []
                    for i in contents {
                        
                        articelArray.append(HomeArticleModel(contentID: String(i.contentID),
                                                             title: i.title,
                                                             description: i.description,
                                                             avatar: i.avatar,
                                                             source: i.source,
                                                             publisherLogo: i.publisherLogo,
                                                             publisherIcon: i.publisherIcon,
                                                             date: i.date))
                        
                    }
                    
                    //changed vc state ( first time loading, when vc is loading state)
                    if self.state == .loading {
                        
                        self.state = .loaded
                        
                    }
                    
                    // add data to datasource
                    self.articleData.append(contentsOf: articelArray)
                    
                }
                
            case .failure(let err):
                print("Error: \(err)")
                
                self.state = .error
                
                DispatchQueue.main.async {
                    
                    self.delegate?.reloadData()
                    
                }
                
            }
        }
        
    }
    
    //get data score board
    func getScoreBoardData(compID: Int, date: String) {
        
        QueryService.sharedService.get(MatchAPITarget.matchByDate(compID: String(compID),
                                                                  date: date,
                                                                  start: 0,
                                                                  size: 25)) {
            
            [weak self]
            (result: Result<ResponseModel<MatchModel>, Error>) in
            guard let self = self else {
                return
            }
            var soccerMatchsArray: [HomeScoreBoardModel] = []
            switch result {
                
            case .success(let res):
                
                if let soccerMatch = res.data?.soccerMatch {
                    
                    for i in soccerMatch {
                        
                        soccerMatchsArray.append(HomeScoreBoardModel(
                            matchID: i.matchID,
                            status: i.matchStatus,
                            competition: i.competition.competitionName,
                            competitionID: i.competition.competitionID,
                            time: i.time,
                            startTime: i.startTime,
                            homeLogo: i.homeTeam.teamLogo,
                            homeName: i.homeTeam.teamName,
                            homeScore: i.homeScored,
                            awayLogo: i.awayTeam.teamLogo,
                            awayName: i.awayTeam.teamName,
                            awayScore: i.awayScored))
                        
                    }
                    
                }
                
                self.scoreBoardData.append(contentsOf: soccerMatchsArray)
                if self.scoreBoardData.isEmpty {
                    
                    self.scoreBoardExist = false
                    return
                    
                }
                
                self.scoreBoardExist = true
                
                
            case .failure(let err):
                self.scoreBoardData.append(contentsOf: soccerMatchsArray)
                print(err)
                
            }
            
        }
    }
    
    //get data competition
    func getCompetitionData() {
        
        QueryService.sharedService.get(CompetitionAPITarget.hot) {
            
            [weak self]
            (result: Result<ResponseModel<CompetitionModel>, Error>) in
            guard let self = self else {
                return
            }
            var competitionArray: [HomeCompetitionModel] = []
            switch result {
                
            case .success(let res):
                
                if let contents = res.data?.soccerCompetitions {
                    
                    
                    for i in contents {
                        
                        competitionArray.append(HomeCompetitionModel(logo: i.competitionLogo,
                                                                     name: i.competitionName))
                        
                    }
                    
                    self.competitionData.append(contentsOf: competitionArray)
                    
                    //Check if competition exist
                    if self.competitionData.isEmpty {
                        
                        self.competitionExist = false
                        return
                        
                    }
                    self.competitionExist = true
                    //Add location for competition cell
                    if self.competitionLocation.isEmpty {
                        
                        self.competitionLocation.insert(self.competitionIndex)
                        return
                        
                    }
                    
                    self.competitionLocation.insert( self.articleData.count + self.competitionIndex)
                    
                }
                
            case .failure(let err):
                
                self.competitionData.append(contentsOf: competitionArray)
                print(err)
                
            }
        }
    }
    
    
    //Refresh data source
    func refresh() {
        
        articleData = []
        scoreBoardData = []
        competitionData = []
        
        apiLoadedCount = 0
        scoreBoardAPILoaded = false
        competitionAPILoaded = false
        isVCLoaded = false
        
        self.delegate?.getData()
        
    }
    
}


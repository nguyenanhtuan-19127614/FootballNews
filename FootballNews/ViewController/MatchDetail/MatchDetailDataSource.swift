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
    
    //Contain to show
    var selectedContent: MatchDetailContent = .news

    //State
    var state: ViewControllerState = .loading
    
    var cacheActive = false
    var isVCLoaded = false
    
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
            
            lock.lock()
            apiLoadedCount += 1
            lock.unlock()
            
        }
    }
    
    //Competition ranking data
    var rankingData: [RankingModel] = [] {
        
        didSet {
            
            lock.lock()
            apiLoadedCount += 1
            lock.unlock()
            
        }

    }
    
    func getRelatedArticelData(matchID: Int?) {
        
        guard let matchID = matchID else {
            return
        }
        
        QueryService.sharedService.get(ContentAPITarget.match(id: String(matchID), start: 0, size: 20)) {
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            
            guard let self = self else {
                return
            }
            
            switch result {
                
            case .success(let res):
                
                if let contents = res.data?.contents {
                    
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
    
                    //changed vc state
                    if self.state == .loading {
                        
                        self.state = .loaded
                        
                    }
                    // add data to datasource
                    self.articleData.append(contentsOf: articelArray)
                    
                }
                
            
            case .failure(let err):
                
                print("Error: \(err)")
               
            }
        }
    }
    
    func getCompetitionRankingData(competitionID: Int?) {
        
        guard let competitionID = competitionID else {
            return
        }
        
        QueryService.sharedService.get(CompetitionAPITarget.standing(id: String(competitionID))) {
            [weak self]
            (result: Result<ResponseModel<CompetitionStandingModel>, Error>) in
            
            guard let self = self else {
                return
            }
            
            var rankingArray: [RankingModel] = []
            
            switch result {
                
            case .success(let res):
                
                if let contents = res.data?.soccerStandings {
                    
                    
                    for i in contents {
                        
                        rankingArray.append(RankingModel(teamName: i.teamName,
                                                         totalStat: i.total,
                                                         homeStat: i.home,
                                                         awayStat: i.away))
                        
                    }
    
                }
                
            case .failure(let err):
                
                print("Error: \(err)")
          
            }
            // add data to datasource
            self.rankingData.append(contentsOf: rankingArray)
        }
        
    }
}

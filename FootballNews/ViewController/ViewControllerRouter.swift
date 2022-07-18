//
//  ViewControllerRouter.swift
//  FootballNews
//
//  Created by LAP13606 on 11/07/2022.
//

import Foundation
import UIKit

enum Destination {
    
    case detailArticle(dataArticle: HomeArticleModel?)
    case detailArticleOffline(dataArticle: ArticelDetailModel?, headerData: HomeArticleModel?)
    case detailMatch(dataMatch: HomeScoreBoardModel?)
    case detailCompetition(dataComp: HomeCompetitionModel?)
    case detailTeam(dataTeam: TeamInfoData?)
    case searchArticle
    
}

class ViewControllerRouter {
    
    static var shared = ViewControllerRouter()
    private init() {}
    
    private weak var navController: UINavigationController?
   
    func setUpNavigationController(_ navController: UINavigationController?) {
        self.navController = navController
    }
    
    func routing(to des: Destination) {
        
        guard let desVC = self.createViewController(des: des) else {
            return
        }
        self.navController?.pushViewController(desVC, animated: true)
        
    }
    
    private func createViewController(des: Destination) -> UIViewController? {
        
        switch des {
            
        case .detailArticle(let dataArticle):
            
            let articleDetailVC = ArticelDetailController()
            guard let dataArticle = dataArticle else {
                return nil
            }
            articleDetailVC.passHeaderDetail(data: dataArticle)
            return articleDetailVC
            
        case .detailArticleOffline(dataArticle: let dataArticle, headerData: let header):
            
            let articleDetailVC = ArticelDetailController()
            guard let dataArticle = dataArticle,
                  let header = header else {
                return nil
            }
            articleDetailVC.passHeaderDetail(data: header)
            articleDetailVC.passArticelDetail(detail: dataArticle)
            articleDetailVC.changeState(state: .offline)
            
            return articleDetailVC
        
        case .detailMatch(let dataMatch):
            
            let matchDetailVC = MatchDetailController()
            guard let dataMatch = dataMatch else {
                return nil
            }
            matchDetailVC.passHeaderData(scoreBoard: dataMatch)
            return matchDetailVC
            
        case .detailCompetition(dataComp: let dataComp):
            
            let competitionDetailVC = CompetitionDetailController()
            guard let dataComp = dataComp else {
                return nil
            }
            competitionDetailVC.passHeaderData(competition: dataComp)
            return competitionDetailVC
            
        case .detailTeam(dataTeam: let dataTeam):
            
            let teamDetailVC = TeamDetailController()
            guard let dataTeam = dataTeam else {
                return nil
            }
            teamDetailVC.passHeaderData(teamInfo: dataTeam)
            return teamDetailVC
            
        case .searchArticle:
            
            let searchVC = SearchArticleViewController()
            return searchVC
            
        }
       
    }
    
   
}

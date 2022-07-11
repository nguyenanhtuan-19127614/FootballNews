//
//  ViewControllerRouter.swift
//  FootballNews
//
//  Created by LAP13606 on 11/07/2022.
//

import Foundation
import UIKit

class ViewControllerRouter {
    
    private weak var navController: UINavigationController?
    
    enum Destination {
        
        case detailArticle(dataArticle: HomeArticleModel?)
        case detailArticleOffline(dataArticle: ArticelDetailModel?)
        case detailMatch(dataMatch: HomeScoreBoardModel?)
        
    }
    
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
            
        case .detailArticleOffline(dataArticle: let dataArticle):
            
            let articleDetailVC = ArticelDetailController()
            guard let dataArticle = dataArticle else {
                return nil
            }
            articleDetailVC.changeState(state: .offline)
            articleDetailVC.passArticelDetail(detail: dataArticle)
            return articleDetailVC
        
        case .detailMatch(let dataMatch):
            
            let matchDetailVC = MatchDetailController()
            guard let dataMatch = dataMatch else {
                return nil
            }
            matchDetailVC.passHeaderData(scoreBoard: dataMatch)
            return matchDetailVC
            
        }
        
    }
    
   
}

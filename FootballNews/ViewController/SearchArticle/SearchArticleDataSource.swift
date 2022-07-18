//
//  SearchArticleDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 18/07/2022.
//

import Foundation
import UIKit

enum ShowedArticles {
    
    case hotArticles
    case searchArticles
}

class SearchArticleDataSource {
    
    weak var delegate: SearchArticleViewController?
    
    var state: ViewControllerState = .loading
    
    var showContent: ShowedArticles = .hotArticles
    
    //query param
    var startArticel = 0
    var articelLoadSize = 20
    
    //ArticleData get from home viewcontroller 
    var hotArticles: [HomeArticleModel?] = [] {
        didSet {
            
            delegate?.reloadData()
        }
    }
    
    //ArticleData get from search API
    var searchArticles: [HomeArticleModel?] = [] 
    
    
    //get data home news listing
    func getHotArticelData() {
        
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
                    
                 
                    var articelArray: [HomeArticleModel?] = []
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
                    if self.state == .loading  {
                        
                        self.state = .loaded
                       
                    }

                    self.hotArticles.append(contentsOf: articelArray)
                    
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
}

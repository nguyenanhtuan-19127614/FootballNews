//
//  ArticleDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 18/06/2022.
//

import Foundation
import UIKit

struct ArticelDetailData {
    
    var title: String
    var description: String
    
    var source: String
    var sourceLogo: String
    
    var body: [Body]
    
}

class ArticelDetailController: UIViewController {
    
    var contentID: String? = nil
    var detailData: ArticelDetailData?
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        let view = UIView()
        view.backgroundColor = .white
        
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    //MARK: GET Data Functions
    func getArticelDetailData(_ contentID: String?) {
        
        guard let contentID = contentID else {
            return
        }
        
        QueryService.sharedService.get(ContentAPITarget.detail(contentID: contentID)) {
            
            (result: Result<ResponseModel<ContentModel>, Error>) in
            
            switch result {
            case .success(let data):
                
                guard let content = data.data?.content else {
                    return
                }
                
                print(content.title)
                print(content.description)
                print(content.source)
                print(content.publisherLogo)
                print(content.body!)
                
            case .failure(let err):
                print(err)
                      
            }
            
            
        }
        
    }
    
    //MARK: Observers
    func addObservers() {
        
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(getDatafromHome(_:)),
                                       name: NSNotification.Name ("HomeToArticel"), object: nil)
        
    }
    
    //MARK: Observers function
    @objc func getDatafromHome(_ notification: Notification){
        
        if notification.object is HomeArticleData {
            
            self.contentID = (notification.object as! HomeArticleData).contentID
        
        }
        getArticelDetailData(self.contentID)
       
    }
}

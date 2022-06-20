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
    var date: Int
    var description: String
    
    var source: String
    var sourceLogo: String
    
    
    var body: [Body]?
    
}

class ArticelDetailController: UIViewController {
    
    var contentID: String? = nil
    var detailData: ArticelDetailData?
    
    var articleDetailCollection: UICollectionView?
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        let view = UIView()
        view.backgroundColor = .white
        
        //MARK: Detail Articel Collection
        let detailArticelLayout = UICollectionViewFlowLayout()
        detailArticelLayout.itemSize = CGSize(width: self.view.bounds.width/1.5,
                                           height: self.view.bounds.height/6)
        detailArticelLayout.minimumLineSpacing = 20
        detailArticelLayout.scrollDirection = .horizontal
        
        articleDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: detailArticelLayout)
        
        

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
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            
            switch result {
            case .success(let data):
                
                guard let content = data.data?.content else {
                    return
                }
                
                self?.detailData = ArticelDetailData(title: content.title,
                                                     date: content.date,
                                                     description: content.description,
                                                     source: content.source,
                                                     sourceLogo: content.publisherLogo,
                                                     body: content.body)
                
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

//MARK: Datasource Extension
extension ArticelDetailController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailArticleCell", for: indexPath) as! HomeArticleCell
        
        articelCell.backgroundColor = UIColor.white
        
        return articelCell
        
    }
    
}

//MARK: Delegate Extension
extension ArticelDetailController: UICollectionViewDelegate {
    
    
}

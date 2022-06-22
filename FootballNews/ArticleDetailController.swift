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
    var sourceIcon: String
    
    var body: [Body]?
    
}



class ArticelDetailController: UIViewController {
    
    var contentBodyCount = 0
    var relatedCount = 0
    
    var contentID: String? = nil
    var detailData: ArticelDetailData?
    var relatedArticleData: [HomeArticleData] = []
    
    var articleDetailCollection: UICollectionView?
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        let view = UIView()
        view.backgroundColor = .white
        
        //MARK: Detail Articel Collection
        let detailArticelLayout = UICollectionViewFlowLayout()
        detailArticelLayout.minimumLineSpacing = 25
        
        articleDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: detailArticelLayout)
        
        articleDetailCollection?.register(ArticelDetailHeaderCell.self, forCellWithReuseIdentifier: "ArticelDetailHeaderCell")
        articleDetailCollection?.register(ArticelDetailTextCell.self, forCellWithReuseIdentifier: "ArticelDetailTextCell")
        articleDetailCollection?.register(ArticelDetailImageCell.self, forCellWithReuseIdentifier: "ArticelDetailImageCell")
        articleDetailCollection?.register(HomeArticleCell.self, forCellWithReuseIdentifier: "ArticelDetailRelatedCell")
        articleDetailCollection?.dataSource = self
        articleDetailCollection?.delegate = self
        
        addSubviewsLayout()
        view.addSubview(articleDetailCollection ?? UICollectionView())
        
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        //articleDetailCollection?.scrollsToTop = true
        super.viewDidLoad()
        
        
    }
    
    //MARK: viewWillDisappear() state - clear all old data
   
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            
            self.resetData()
            articleDetailCollection?.reloadData()
            
        }
        
    }
    
    //MARK: Reset Function
    func resetData() {
        
        self.detailData = nil
        self.relatedArticleData = []
        self.contentBodyCount = 0
        self.relatedCount = 0
        
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
                                                     sourceIcon: content.publisherIcon,
                                                     body: content.body)
                
                self?.contentBodyCount += self?.detailData?.body?.count ?? 0
                
                guard let related = data.data?.related else {
                    
                    return
                    
                }
                
                for i in related.contents {
                    
                    self?.relatedArticleData.append(HomeArticleData(contentID: String(i.contentID),
                                                                    avatar: i.avatar,
                                                                    title: i.title,
                                                                    author: i.publisherLogo,
                                                                    link: i.url))
                    
                }
                
                
                
                self?.relatedCount += self?.relatedArticleData.count ?? 0
                
                DispatchQueue.main.async {
                    
                    self?.articleDetailCollection?.reloadData()
                    
                }
                
            case .failure(let err):
                print(err)
                      
            }
            
            
        }
        
    }
    
    //MARK: Function to add layout for subviews
    func addSubviewsLayout() {
      
        //Listing Collection
        articleDetailCollection?.frame = CGRect(x: 0,
                                                y: 10,
                                                width: self.view.bounds.width,
                                                height: self.view.bounds.height)
        
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
        
        return 1 + self.contentBodyCount + self.relatedCount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Header Part
        if indexPath.row == 0 {
            
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailHeaderCell", for: indexPath) as! ArticelDetailHeaderCell
            
            headerCell.backgroundColor = UIColor.white
            if let detailData = detailData {
                
                headerCell.loadData(detailData)
                
            }
         
            return headerCell
            
        } else if indexPath.row <= contentBodyCount { //Body Part
            
            guard let bodyContent = detailData?.body else {
                
                return UICollectionViewCell()
                
            }
            
            if bodyContent[indexPath.row - 1].type == "text" {
                
                let bodyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailTextCell", for: indexPath) as! ArticelDetailTextCell
                
                bodyCell.backgroundColor = UIColor.white
                bodyCell.loadData(bodyContent[indexPath.row - 1].content)
              
                bodyCell.bounds.size = CGSize(width: self.view.bounds.width,
                                              height: bodyCell.calculateHeight())
                
                return bodyCell
                
                
            } else {
                
                let bodyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailImageCell", for: indexPath) as! ArticelDetailImageCell
                
                bodyCell.backgroundColor = UIColor.white

                bodyCell.loadData(bodyContent[indexPath.row - 1].content)
                return bodyCell
                
            }
            
        } else {
            
            let relatedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailRelatedCell", for: indexPath) as! HomeArticleCell
            
            relatedCell.backgroundColor = UIColor.white
            
            let index = indexPath.row - self.contentBodyCount - 1
            print(index)
            relatedCell.loadData(inputData: self.relatedArticleData[index])
            return relatedCell
        
        }
        
    }
    
}

//MARK: Delegate Extension
extension ArticelDetailController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row > contentBodyCount {
            
            print("User tapped on item \(indexPath.row)")
            
            let index = indexPath.row - self.contentBodyCount - 1
            let contentID = relatedArticleData[index].contentID
            resetData()
            getArticelDetailData(contentID)
            
        }
    }
    
}

//MARK: Delegate Flow Layout extension
extension ArticelDetailController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let detailData = detailData else {
            
            return CGSize(width: 0,
                          height: 0)
            
        }
        
        if indexPath.row == 0 {
            
            let titleLabel = UILabel()
            titleLabel.text = detailData.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
            
            let descriptionLabel = UILabel()
            descriptionLabel.text = detailData.description
            descriptionLabel.font = UIFont.boldSystemFont(ofSize: 25)
            
            var height = titleLabel.calculateHeight(cellWidth: self.view.bounds.width - 35)
            height += descriptionLabel.calculateHeight(cellWidth: self.view.bounds.width - 35)
            height += 30 + 50
            
            print("height: \(height)")
            return CGSize(width: self.view.bounds.width ,
                          height: height)
            
        } else if indexPath.row <= contentBodyCount {
            
            guard let bodyContent = detailData.body else {
                
                return CGSize(width: 0,
                              height: 0)
                
            }
            
                if bodyContent[indexPath.row - 1].type == "text" {
                
                let contentLabel = UILabel()
                contentLabel.text = bodyContent[indexPath.row - 1].content
                contentLabel.font =  UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 16)
                
                return CGSize(width: self.view.bounds.width - 30,
                              height: contentLabel.calculateHeight(cellWidth: self.view.bounds.width ))
                
            } else {
                
                
                return CGSize(width: self.view.bounds.width,
                              height: 250)
                
            }
            
        }
        
        return CGSize(width: self.view.bounds.width,
                      height: self.view.bounds.height/7)
        
    }
}

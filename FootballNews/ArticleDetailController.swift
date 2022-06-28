//
//  ArticleDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 18/06/2022.
//

import Foundation
import AVFoundation
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
    
    var contentID: String = ""
    var isLoad = false
    
    var contentBodyCount = 0
    var relatedCount = 0
    
    var detailData: ArticelDetailData?
    var relatedArticleData: [HomeArticleData] = []
    
    var articleDetailCollection: UICollectionView = {
        
        let detailArticelLayout = UICollectionViewFlowLayout()
        detailArticelLayout.minimumLineSpacing = 15
        
        let articleDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: detailArticelLayout)
        
        articleDetailCollection.register(ArticelDetailHeaderCell.self, forCellWithReuseIdentifier: "ArticelDetailHeaderCell")
        articleDetailCollection.register(ArticelDetailTextCell.self, forCellWithReuseIdentifier: "ArticelDetailTextCell")
        articleDetailCollection.register(ArticelDetailImageCell.self, forCellWithReuseIdentifier: "ArticelDetailImageCell")
        articleDetailCollection.register(HomeArticleCell.self, forCellWithReuseIdentifier: "ArticelDetailRelatedCell")
        
        return articleDetailCollection
    }()
  
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
      
        
        //MARK: Create customView
        let view = UIView()
        view.backgroundColor = .white
        
        //MARK: Detail Articel Collection
        
        articleDetailCollection.dataSource = self
        articleDetailCollection.delegate = self
        
        
        view.addSubview(articleDetailCollection)
        
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
    
        super.viewDidLoad()
        addSubviewsLayout()
        
        getArticelDetailData(contentID)
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
                //Load detail data
                self?.detailData = ArticelDetailData(title: content.title,
                                                     date: content.date,
                                                     description: content.description,
                                                     source: content.source,
                                                     sourceLogo: content.publisherLogo,
                                                     sourceIcon: content.publisherIcon,
                                                     body: content.body)
                
               
                
                //number of content
                self?.contentBodyCount += self?.detailData?.body?.count ?? 0
                
                guard let related = data.data?.related else {
                    
                    return
                    
                }
                //Load related contents data
                for i in related.contents {
                    
                    self?.relatedArticleData.append(HomeArticleData(contentID: String(i.contentID),
                                                                    avatar: i.avatar,
                                                                    title: i.title,
                                                                    author: i.publisherLogo,
                                                                    link: i.url))
                    
                }
                
                
                //related content numbers
                self?.relatedCount += self?.relatedArticleData.count ?? 0
                
                //Set titleview of navigation bar
                
                
                DispatchQueue.main.async {
                   
                    let titleView = CustomTitleView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: self?.view.bounds.width ?? 0,
                                                                  height: self?.view.bounds.height ?? 0))
                    titleView.loadData(url: URL(string: content.publisherLogo))
                    self?.navigationItem.titleView = titleView
                   
                    //Reload Collection
                    self?.articleDetailCollection.reloadData()
                    
                }
                
            case .failure(let err):
                print(err)
                      
            }
            
            
        }
        
    }
    
    //MARK: Function to add layout for subviews
    func addSubviewsLayout() {
      
        articleDetailCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            articleDetailCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            articleDetailCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            articleDetailCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            articleDetailCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            
        ])
    
       
    }
    
    //MARK: Observers
    func addObservers() {
 
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(getContentID(_:)),
                                       name: NSNotification.Name ("SendContentIDToArticel"), object: nil)
        
    }
    
    //MARK: Observers function
    @objc func getContentID(_ notification: Notification) {
        
        if isLoad == false {
            
            if notification.object is HomeArticleData {
                
                guard let homeArticelData = notification.object as? HomeArticleData else {
                    
                    print("Bad data from Home Article list")
                    return
                    
                }
           
                //Load data base on content ID
                contentID = homeArticelData.contentID
                //getArticelDetailData(homeArticelData.contentID)
                isLoad = true
            
            }
            
        }
       
        
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
                bodyCell.loadData(bodyContent[indexPath.row - 1].content,
                                  subtype: bodyContent[indexPath.row - 1].subtype)
              
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
           
            NotificationCenter.default.post(name: NSNotification.Name("ToArticelVC"), object: relatedArticleData[index])
            
        }
    }
    
}

//ListViewDatasource<Data>
//ListViewController
//

//MARK: Delegate Flow Layout extension
extension ArticelDetailController: UICollectionViewDelegateFlowLayout {
    
    //Set size for each cell
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
                contentLabel.font =  UIFont(name: "Helvetica", size: 22.0) ?? UIFont.systemFont(ofSize: 20)
                    
                if let subtype = bodyContent[indexPath.row - 1].subtype {
                    
                    if subtype == "media-caption" {
                        
                        contentLabel.font = contentLabel.font.withSize(18)
                        
                    }
                   
                }
                
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
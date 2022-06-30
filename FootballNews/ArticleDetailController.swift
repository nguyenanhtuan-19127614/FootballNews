//
//  ArticleDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 18/06/2022.
//

import Foundation
import AVFoundation
import UIKit


class ArticelDetailController: UIViewController,ViewControllerDelegate, DataSoureDelegate {
    
    //Delegate
    weak var delegate: ViewControllerDelegate?
    
    var contentID: String = ""
    var publisherLogo: String = ""
    
    // Datasource
    let dataSource = ArticelDetailDataSource()
    
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
    
    
    //MARK: Delegation Function
    func passContentID(contentID: String) {
        
        self.contentID = contentID
        
    }
    
    func passPublisherLogo(url: String) {
        
        self.publisherLogo = url
        
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.articleDetailCollection.reloadData()
            
        }
        
    }
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        //Add delegate for datasource
       
        dataSource.delegate = self
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
    
    //MARK: viewWillAppear() state
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set titleview of navigation bar
        
        let titleView = CustomTitleView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: self.navigationController?.navigationBar.bounds.width ?? 0,
                                                      height: self.navigationController?.navigationBar.bounds.height ?? 0))
        
        titleView.loadData(url: URL(string: self.publisherLogo))
        self.navigationItem.titleView = titleView

    }
    
    
    //MARK: GET Data Functions
    func getArticelDetailData(_ contentID: String?) {
        
        guard let contentID = contentID else {
            return
        }
        
        QueryService.sharedService.get(ContentAPITarget.detail(contentID: contentID)) {
            
            [unowned self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            
            switch result {
            case .success(let data):
                
                guard let content = data.data?.content else {
                    
                    return
                    
                }
                //Load detail data
                let detailData = ArticelDetailData(title: content.title,
                                                     date: content.date,
                                                     description: content.description,
                                                     source: content.source,
                                                     sourceLogo: content.publisherLogo,
                                                     sourceIcon: content.publisherIcon,
                                                     body: content.body)
                
                self.dataSource.detailData = detailData
                
//                //number of content
//                self?.contentBodyCount += self?.detailData?.body?.count ?? 0
//
                guard let related = data.data?.related else {
                    
                    return
                    
                }
                
                var articelArray: [HomeArticleData] = []
                //Load related contents data
                for i in related.contents {
                    
                    articelArray.append(HomeArticleData(contentID: String(i.contentID),
                                                        avatar: i.avatar,
                                                        title: i.title,
                                                        author: i.publisherLogo,
                                                        link: i.url,
                                                        date: i.date))
                    
                }
                
                self.dataSource.relatedArticleData.append(contentsOf: articelArray)
               
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
    
    
}

//MARK: Datasource Extension
extension ArticelDetailController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataSource.dataSourceSize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Header Part
        if indexPath.row == 0 {
            
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailHeaderCell", for: indexPath) as! ArticelDetailHeaderCell
            
            headerCell.backgroundColor = UIColor.white
            if let detailData = self.dataSource.detailData {
                
                headerCell.loadData(detailData)
                
            }
         
            return headerCell
            
        } else if indexPath.row <= dataSource.contentBodySize { //Body Part
            
            guard let bodyContent = dataSource.detailData?.body else {
                
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
            
            let index = indexPath.row - dataSource.contentBodySize - 1
            relatedCell.loadData(inputData: dataSource.relatedArticleData[index])
            return relatedCell
        
        }
        
    }
    
}

//MARK: Delegate Extension
extension ArticelDetailController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Pass data and call articel detail view controller ( Related Articel )
        if indexPath.row > dataSource.contentBodySize {
            
            
            let index = indexPath.row - dataSource.contentBodySize  - 1
            
            let articelDetailVC = ArticelDetailController()
            self.delegate = articelDetailVC
            self.delegate?.passContentID(contentID: dataSource.relatedArticleData[index].contentID)
            self.delegate?.passPublisherLogo(url: dataSource.relatedArticleData[index].author)
            
            navigationController?.pushViewController(articelDetailVC, animated: true)     
            
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
        
    
        guard let detailData = dataSource.detailData else {
            
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
            
        } else if indexPath.row <= dataSource.contentBodySize {
            
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
                              height: self.view.bounds.height/3)
                
            }
            
        }
        
        return CGSize(width: self.view.bounds.width,
                      height: self.view.bounds.height/7)
        
    }
}

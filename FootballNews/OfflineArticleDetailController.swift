//
//  ArticleDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 18/06/2022.
//

import Foundation
//import AVFoundation
import UIKit

//ListViewDatasource<Data>
//ListViewController
//

class OfflineArticelDetailController: UIViewController,ViewControllerDelegate, DataSoureDelegate {
   
    func reloadData() {
        return
    }
    
    func changeState(state: ViewControllerState) {
        return
    }
    
    
    //ViewController State
    var state: ViewControllerState = .offline
    
    //Variable
    var contentID: String = ""
    var publisherLogo: String = ""
    
    // Datasource from diskcache
    var articelDetail: ArticelDetailModel?
    
    //Main Collection
    let articleDetailLayout = UICollectionViewFlowLayout()
    var articleDetailCollection: UICollectionView = {
        
        let articleDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        articleDetailCollection.register(ArticelDetailHeaderCell.self, forCellWithReuseIdentifier: "ArticelDetailHeaderCell")
        articleDetailCollection.register(ArticelDetailBodyTextCell.self, forCellWithReuseIdentifier: "ArticelDetailTextCell")
        articleDetailCollection.register(ArticelDetailBodyImageCell.self, forCellWithReuseIdentifier: "ArticelDetailImageCell")
    
        return articleDetailCollection
        
    }()
    
    
    //MARK: Delegation Function
    func passContentID(contentID: String) {
        
        self.contentID = contentID
        
    }
    
    func passPublisherLogo(url: String) {
        
        self.publisherLogo = url
        
    }
    
    func passArticelDetail(detail: ArticelDetailModel?) {
        guard let detail = detail else {
            return
        }

        self.articelDetail = detail
    }
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()

        //MARK: Create customView
        let view = UIView()
        view.backgroundColor = .white
        
        //MARK: Detail Articel Collection
        
        articleDetailCollection.dataSource = self
        articleDetailCollection.delegate = self
        articleDetailCollection.collectionViewLayout = articleDetailLayout
        
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
                                                      width: (self.navigationController?.navigationBar.bounds.width ?? 0)/2,
                                                      height: (self.navigationController?.navigationBar.bounds.height ?? 0)/2))
        
        titleView.loadData(url: URL(string: self.publisherLogo))
        
        self.navigationItem.titleView = titleView
        
        //set background color
        self.navigationController?.navigationBar.setImageBackground(image: nil)
        
    }
    
    //MARK: Custom Layout
    override func viewDidLayoutSubviews() {
        
        articleDetailLayout.sectionInsetReference = .fromSafeArea
        articleDetailLayout.minimumLineSpacing = 15
       
    }
    //MARK: GET Data Functions
    func getArticelDetailData(_ contentID: String?) {
        
       return
        
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
extension OfflineArticelDetailController: UICollectionViewDataSource {

    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (articelDetail?.body?.count ?? 0) + 1
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //Loaded state
        if indexPath.row == 0 {
            
            //Header Part
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailHeaderCell", for: indexPath) as! ArticelDetailHeaderCell
            
            headerCell.backgroundColor = UIColor.white
            if let detailData = self.articelDetail {
                
                headerCell.loadData(detailData)
                
            }
         
            return headerCell
            
        } else  {
            
            //Body Part
            guard let bodyContent = articelDetail?.body else {
                
                return UICollectionViewCell()
                
            }
            
            if bodyContent[indexPath.row - 1].type == "text" {
                
                let bodyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailTextCell", for: indexPath) as! ArticelDetailBodyTextCell
                
                bodyCell.backgroundColor = UIColor.white
                bodyCell.loadData(bodyContent[indexPath.row - 1].content,
                                  subtype: bodyContent[indexPath.row - 1].subtype)
              
                bodyCell.bounds.size = CGSize(width: self.view.bounds.width,
                                              height: bodyCell.calculateHeight())
                
                return bodyCell
                
                
            } else {
                
                let bodyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailImageCell", for: indexPath) as! ArticelDetailBodyImageCell
                
                bodyCell.backgroundColor = UIColor.white

                bodyCell.loadData(bodyContent[indexPath.row - 1].content)
                return bodyCell
                
            }
            
        }
    }
    
}


//MARK: Delegate Flow Layout extension
extension OfflineArticelDetailController: UICollectionViewDelegateFlowLayout {
    
    //Set size for each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
      
        guard let detailData = articelDetail else {
            
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
            
            var height = titleLabel.calculateHeight(cellWidth: totalWidth - 35)
            height += descriptionLabel.calculateHeight(cellWidth: totalWidth - 35)
            height += 50

            
            return CGSize(width: totalWidth ,
                          height: height)
            
        } else {
            
            guard let bodyContent = detailData.body else {
                
                return CGSize(width: 0,
                              height: 0)
                
            }
            
            if bodyContent[indexPath.row - 1].type == "text" {
                
                let contentLabel = UILabel()
                contentLabel.text = bodyContent[indexPath.row - 1].content
                contentLabel.font =  UIFont(name: "TimesNewRomanPS-BoldMT", size: 22.0) ?? UIFont.systemFont(ofSize: 20)
                    
                if let subtype = bodyContent[indexPath.row - 1].subtype {
                    
                    if subtype == "media-caption" {
            
                        contentLabel.font =  UIFont(name: "TimesNewRomanPS-ItalicMT", size: 18.0) ?? UIFont.systemFont(ofSize: 18)
                        
                    }
                   
                }
                
                return CGSize(width: totalWidth - 30,
                              height: contentLabel.calculateHeight(cellWidth: totalWidth - 30 ))
               
                
            } else {
                
                return CGSize(width: totalWidth,
                              height: totalHeight/3)
                
            }
            
        }
        
       
        
    }
    
   
}

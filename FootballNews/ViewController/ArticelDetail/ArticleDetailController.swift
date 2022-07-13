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

class ArticelDetailController: UIViewController, DataSoureDelegate {
    
    var headerHeight: CGFloat = 0
    
    // Datasource
    let dataSource = ArticelDetailDataSource()
    
    //Main Collection
    let articleDetailLayout = UICollectionViewFlowLayout()
    var articleDetailCollection: UICollectionView = {
        
        let articleDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        articleDetailCollection.register(ArticelDetailHeaderCell.self, forCellWithReuseIdentifier: "ArticelDetailHeaderCell")
        articleDetailCollection.register(ArticelDetailBodyTextCell.self, forCellWithReuseIdentifier: "ArticelDetailTextCell")
        articleDetailCollection.register(ArticelDetailBodyImageCell.self, forCellWithReuseIdentifier: "ArticelDetailImageCell")
        articleDetailCollection.register(ArticleCell.self, forCellWithReuseIdentifier: "ArticelDetailRelatedCell")
        articleDetailCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "LoadMoreCell")
        articleDetailCollection.register(ErrorOccurredCell.self, forCellWithReuseIdentifier: "ErrorCell")
        
        return articleDetailCollection
        
    }()
    
    
    //MARK: Delegation Function
    
    
    func passHeaderDetail(data: HomeArticleModel) {
        
        self.dataSource.headerData = data
        
    }
    
    func passArticelDetail(detail: ArticelDetailModel?) {
        guard let detail = detail else {
            return
        }
        
        self.dataSource.detailData = detail
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.articleDetailCollection.reloadData()
            
        }
        
    }
    
    func getData() {
        
        if dataSource.state == .offline {
            return
        }
        self.dataSource.getArticelDetailData()
        
    }
    
    func changeState(state: ViewControllerState) {
        
        self.dataSource.state = state
        self.articleDetailCollection.reloadData()
        
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
        articleDetailCollection.collectionViewLayout = articleDetailLayout
        
        view.addSubview(articleDetailCollection)
        
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //get data
        if dataSource.state == .loading {
            
            self.getData()
            
        }
        
        ViewControllerRouter.shared.setUpNavigationController(self.navigationController)
        addSubviewsLayout()
        
    }
    
    //MARK: viewWillAppear() state
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set button color
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        
        //Back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Set titleview of navigation bar
        
        let titleView = CustomTitleView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: (self.navigationController?.navigationBar.bounds.width ?? 0)/2,
                                                      height: (self.navigationController?.navigationBar.bounds.height ?? 0)/2))
        
        titleView.loadData(url: URL(string: dataSource.headerData?.publisherLogo ?? ""))
        
        self.navigationItem.titleView = titleView
        
        //set background color
        self.navigationController?.navigationBar.setImageBackground(image: nil)
        
        
        
    }
    
    //MARK: Custom Layout
    override func viewDidLayoutSubviews() {
        
        articleDetailLayout.sectionInsetReference = .fromSafeArea
        articleDetailLayout.minimumLineSpacing = 15
        
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
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let state = dataSource.state
        
        switch state {
            
        case .loading:
            
            return 2
            
        case .loaded:
            
            return dataSource.dataSourceSize
            
        case .error:
            return 2
            
        case .offline:

            return (self.dataSource.detailData?.body?.count ?? 0) + 1
            
        }
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row == 0 {
            
            //Header Part
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailHeaderCell", for: indexPath) as! ArticelDetailHeaderCell
            
            headerCell.backgroundColor = UIColor.white
            if let headerData = self.dataSource.headerData {
                
                headerCell.loadData(headerData)
                
            }
            
            return headerCell
        }
        
        let state = dataSource.state
       
        switch state {
        case .loading:
            
            //Loading State
            let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreIndicatorCell
            
            indicatorCell.indicator.startAnimating()
            return indicatorCell
            
        case .loaded:
            if indexPath.row > dataSource.contentBodySize {
                
                let relatedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticelDetailRelatedCell", for: indexPath) as! ArticleCell
                
                relatedCell.backgroundColor = UIColor.white
                
                let index = indexPath.row - dataSource.contentBodySize - 1
                relatedCell.loadData(inputData: dataSource.relatedArticleData[index])
                return relatedCell
                
            } else {
                
                //Body Part
                guard let bodyContent = dataSource.detailData?.body else {
                    
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
            
        case .error:
            
            //Error State
            let errorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCell", for: indexPath) as! ErrorOccurredCell
            errorCell.delegate = self
            return errorCell
            
        case .offline:
           
            if self.dataSource.detailData == nil {
                
                dataSource.state = .error
                DispatchQueue.main.async {
                    self.articleDetailCollection.reloadData()
                }
                
            }
            
            //Body Part
            guard let bodyContent = dataSource.detailData?.body else {
                
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

//MARK: Delegate Extension
extension ArticelDetailController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Tap Event
        
        if dataSource.state == .offline {
            return
        }
        //Pass data and call articel detail view controller (Related Articel)
        if indexPath.row > dataSource.contentBodySize {
            
            
            let index = indexPath.row - dataSource.contentBodySize  - 1
            
            ViewControllerRouter.shared.routing(to: .detailArticle(dataArticle: dataSource.relatedArticleData[index]))
            
        }
    }
    
}

//MARK: Delegate Flow Layout extension
extension ArticelDetailController: UICollectionViewDelegateFlowLayout {
    
    //Set size for each cell

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
        let state = dataSource.state
        
        guard let headerData = dataSource.headerData else {
            
            return CGSize(width: 0,
                          height: 0)
            
        }
        
        if indexPath.row == 0 {
            
            let titleLabel = UILabel()
            titleLabel.text = headerData.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 27)
            titleLabel.addLineSpacing(lineSpacing: 5)
            
            let descriptionLabel = UILabel()
            descriptionLabel.text = headerData.description
            descriptionLabel.font = UIFont.boldSystemFont(ofSize: 23)
            descriptionLabel.addLineSpacing(lineSpacing: 5)
            
            var height = titleLabel.calculateHeight(cellWidth: totalWidth - 35)
            height += descriptionLabel.calculateHeight(cellWidth: totalWidth - 35)
            height += 50 //line spacing of all element
            height += 20 //padding top
            self.headerHeight = height
            return CGSize(width: totalWidth ,
                          height: height)
            
        }
    
        if state == .loading || state == . error {
            
            return CGSize(width: totalWidth,
                          height: totalHeight - self.headerHeight)
            
        }
        
        guard let detailData = dataSource.detailData else {
            
            return CGSize(width: 0,
                          height: 0)
            
        }
        
        if indexPath.row <= dataSource.contentBodySize {
            
            guard let bodyContent = detailData.body else {
                
                return CGSize(width: 0,
                              height: 0)
                
            }
            
            if bodyContent[indexPath.row - 1].type == "text" {
                
                let contentLabel = UILabel()
                contentLabel.text = bodyContent[indexPath.row - 1].content
                contentLabel.font =  UIFont(name: "TimesNewRomanPS-BoldMT", size: 22.0) ?? UIFont.systemFont(ofSize: 20)
                contentLabel.addLineSpacing(lineSpacing: 5)
                
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
        
        return CGSize(width: totalWidth,
                      height: totalHeight/7)
        
    }
    
    
}

//
//  MatchDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 06/07/2022.
//

import Foundation
import UIKit

enum MatchDetailContent {
    
    case news
    case ranking
    
}

class MatchDetailController: UIViewController, DataSoureDelegate {

    //Datasource
    let dataSource = MatchDetailDataSource()
    
    //Header
    let headerView = MatchDetailHeader()
    
    //Main CollectionView Layout
    var matchDetailLayout = UICollectionViewFlowLayout()
    
    //Main CollectionView
    var matchDetailCollection: UICollectionView = {
        
        //Custom CollectionView
        let matchDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        matchDetailCollection.backgroundColor = UIColor.white
        matchDetailCollection.contentInsetAdjustmentBehavior = .always
        
        //Register data for CollectionView
        //Cell
        matchDetailCollection.register(HomeArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        matchDetailCollection.register(RankingCell.self, forCellWithReuseIdentifier: "RankingCell")
        matchDetailCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "LoadMoreCell")
        //Section
        matchDetailCollection.register(MatchDetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MatchDetailSectionHeader")
        return matchDetailCollection
        
    }()
    
   
    //MARK: Delegation Function
    func passHeaderData(scoreBoard: HomeScoreBoardModel?) {
        
        guard let scoreBoard = scoreBoard else {
            return
        }
        
        dataSource.headerData = scoreBoard
        loadHeaderData(scoreBoard: scoreBoard)
       
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.matchDetailCollection.reloadData()
            
        }
        
    }
    
    func changeState(state: ViewControllerState) {
        
        self.dataSource.state = state
        self.reloadData()
        
    }
    
    func changeContentMatchDetail(content: MatchDetailContent) {
        self.dataSource.selectedContent = content
    }
    
    func getData() {
        
        if dataSource.state == .offline {
            return
        }
       
        dataSource.getRelatedArticelData(matchID: self.dataSource.headerData?.matchID)
        dataSource.getCompetitionRankingData(competitionID: self.dataSource.headerData?.competitionID)
        
    }
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        
        //Add delegate for datasource
        dataSource.delegate = self
        
        //MARK: Create customView
        let view = UIView()
        view.backgroundColor = .white
        
        //MARK: Collection View
        
        matchDetailCollection.dataSource = self
        matchDetailCollection.delegate = self
        
        matchDetailCollection.collectionViewLayout = matchDetailLayout
        
        //MARK: Add layout and Subviews
        
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.view.bounds.width,
                                  height: self.view.bounds.height/5)
   
        view.addSubview(matchDetailCollection)
        view.addSubview(headerView)
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
    
        super.viewDidLoad()
        ViewControllerRouter.shared.setUpNavigationController(self.navigationController)
        addSubviewsLayout()
      
    }
   
    //MARK: Add subviews layout
    func addSubviewsLayout() {
    
        matchDetailCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            matchDetailCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                       constant: headerView.bounds.height),
            matchDetailCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            matchDetailCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            matchDetailCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
        
    }
    
    //MARK: Custom Layout
    override func viewDidLayoutSubviews() {
        
        matchDetailLayout.sectionInsetReference = .fromSafeArea
        matchDetailLayout.sectionHeadersPinToVisibleBounds = true
       
    }
    
    //MARK: viewWillAppear() state
    override func viewWillAppear( _ animated: Bool) {
        
        super.viewWillAppear(animated)
        //Custom Navigation Bars
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if #available(iOS 13.0, *) {
            
            let startColor = CGColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1)
            let middleColor = CGColor(red: 0.05, green: 0.39, blue: 0.59, alpha: 1)
            
            navigationController?.navigationBar.setTitleAttribute(color: .white,
                                                                  font: UIFont.boldSystemFont(ofSize: 20))
            navigationController?.navigationBar.setGradientBackground(colors: [startColor,middleColor])
            
        }
        
        //Back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
        //Title
        self.title = dataSource.headerData?.competition
        
        //Getdata
        if dataSource.state == .loading {
            self.getData()
        }
        
    }
    
    //MARK: Load Data Functions
    
    func loadHeaderData(scoreBoard: HomeScoreBoardModel) {
        
        self.headerView.loadData(scoreBoard: scoreBoard)
        
    }
    
}


//MARK: Datasource Extension
extension MatchDetailController: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let state = dataSource.state
        switch state {
        case .loading:
            
            return 1
            
        case .loaded:
            
            //news articel content
            if dataSource.selectedContent == .news {
                return dataSource.articleData.count
            }
            
            return dataSource.rankingData.count
            
        case .error:
            
            return 1
            
        case .offline:
            
            return 0
            
        }
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let state = dataSource.state
        let selectedContent = dataSource.selectedContent
        
        guard state == .loaded else {
            
            let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreIndicatorCell
            
            indicatorCell.indicator.startAnimating()
            
            return indicatorCell
            
        }
         
        //News Articel Containt
        if selectedContent == .news {
            
            let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
            
            articelCell.backgroundColor = UIColor.white
            articelCell.loadData(inputData: self.dataSource.articleData[indexPath.row])
           
            return articelCell
            
        }
        
        let rankingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingCell", for: indexPath) as! RankingCell
        
        
        rankingCell.loadData(inputData: self.dataSource.rankingData[indexPath.row],
                             index: indexPath.row)
       
        return rankingCell
        
    }
    
    //return section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MatchDetailSectionHeader", for: indexPath) as! MatchDetailSectionHeader
            sectionHeader.delegate = self
            return sectionHeader
            
            
       } else {
           
            return UICollectionReusableView()
           
       }
    }
}

//MARK: Delegate Extension
extension MatchDetailController: UICollectionViewDelegate {
    
    //Tap Event
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch dataSource.selectedContent {
            
        case .news:
            ViewControllerRouter.shared.routing(to: .detailArticle(dataArticle: dataSource.articleData[indexPath.row]))
            
        case .ranking:
            return
        
        }

    }

}

//MARK: Delegate Flow Layout extension
extension MatchDetailController: UICollectionViewDelegateFlowLayout {
    
    //Cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
        let state = dataSource.state
        let selectedContent = dataSource.selectedContent
        
        switch state {
        case .loading:
            return CGSize(width: totalWidth ,
                          height: collectionView.bounds.height)
        case .loaded:
            
            //news articel content
            if selectedContent == .news {
                return CGSize(width: totalWidth,
                              height: totalHeight/7)
            } else {
                //ranking content
                return CGSize(width: totalWidth ,
                              height: collectionView.bounds.height/15)
            }
            
        case .error:
            return CGSize(width: totalWidth ,
                          height: collectionView.bounds.height)
        case .offline:
            
            return CGSize(width: 0 ,
                          height: 0)
            
        }
        
        
    }
    
    //Line spaceing between cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if dataSource.selectedContent == .news {
            
            return 10
            
        } else {
            
            return 0
            
        }
        
    }
    
    //Section Header Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height/14)
        
    }

}


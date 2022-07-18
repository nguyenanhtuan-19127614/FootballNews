//
//  CompetitionDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 12/07/2022.
//

import Foundation
import UIKit

enum CompetitionDetailContent {
    
    case news
    case ranking
   
}

class CompetitionDetailController: UIViewController, DataSoureDelegate {
    
    //Datasource
    let dataSource = CompetitionDetailDataSource()
    
    //Header
    let headerView = CompetitionDetailHeader()
    
    //Main CollectionView Layout
    var compDetailLayout = UICollectionViewFlowLayout()
    
    //Main CollectionView
    var compDetailCollection: UICollectionView = {
        
        //Custom CollectionView
        let compDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        compDetailCollection.backgroundColor = UIColor.white
        compDetailCollection.contentInsetAdjustmentBehavior = .always
        
        //Register data for CollectionView
        //Cell
        compDetailCollection.register(ArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        compDetailCollection.register(RankingCell.self, forCellWithReuseIdentifier: "RankingCell")
        compDetailCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "LoadMoreCell")
        //Section
        compDetailCollection.register(CompetitionDetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CompetitionDetailSectionHeader")
        return compDetailCollection
        
    }()
    //MARK: Delegation Function
    
    func passHeaderData(competition: HomeCompetitionModel?) {
        
        guard let competition = competition else {
            return
        }
        
        //dataSource.headerData = scoreBoard
        dataSource.headerData = competition
        loadHeaderData(competition: competition)
       
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.compDetailCollection.reloadData()
            
        }
        
    }
    
    func changeState(state: ViewControllerState) {
        
        dataSource.state = state
        self.reloadData()
        
    }
    
    func changeContentMatchDetail(content: CompetitionDetailContent) {
       
        self.dataSource.selectedContent = content
        
    }
    
    func getData() {
      
        dataSource.getRelatedArticelData(compID: self.dataSource.headerData?.id)
        dataSource.getCompetitionRankingData(competitionID: self.dataSource.headerData?.id)
        
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
        
        compDetailCollection.dataSource = self
        compDetailCollection.delegate = self
        
        compDetailCollection.collectionViewLayout = compDetailLayout
        
        //MARK: Add layout and Subviews
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.view.bounds.width,
                                  height: self.view.bounds.height/5)
       
        view.addSubview(compDetailCollection)
        view.addSubview(headerView)
        self.view = view
        
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
       
        addSubviewsLayout()
        
        //Getdata
        if dataSource.state == .loading {
            self.getData()
        }
      
    }
    
    //MARK: Add subviews layout
    func addSubviewsLayout() {
        
        compDetailCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            compDetailCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: headerView.bounds.height),
            compDetailCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            compDetailCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            compDetailCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
        
    }
    
    //MARK: Custom Layout
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        compDetailLayout.sectionInsetReference = .fromSafeArea
        compDetailLayout.sectionHeadersPinToVisibleBounds = true
       
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
        self.title = "Giải Đấu"
        
        
    }
    
    //MARK: Load Data Functions
    
    func loadHeaderData(competition: HomeCompetitionModel) {
        
        headerView.loadData(compName: competition.name, compLogo: competition.logo)
        
    }
}

//MARK: Datasource Extension
extension CompetitionDetailController: UICollectionViewDataSource {
    
    //return cell number
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
    
    //return cell
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
            
            let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! ArticleCell
            
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
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CompetitionDetailSectionHeader", for: indexPath) as! CompetitionDetailSectionHeader
            sectionHeader.delegate = self
            return sectionHeader
            
            
       } else {
           
            return UICollectionReusableView()
           
       }
    }
    
}

//MARK: Delegate Extension
extension CompetitionDetailController: UICollectionViewDelegate {
    
    //Tap Event
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if dataSource.state == .loading {
            return
        }
        
        switch dataSource.selectedContent {
            
        case .news:
            ViewControllerRouter.shared.routing(to: .detailArticle(dataArticle: dataSource.articleData[indexPath.row]))
            
        case .ranking:
            return
        
        }

    }
    
}

//MARK: Delegate Flow Layout extension
extension CompetitionDetailController: UICollectionViewDelegateFlowLayout {
    
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


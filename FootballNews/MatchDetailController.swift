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

class MatchDetailController: UIViewController, ViewControllerDelegate, DataSoureDelegate {
    
    //Delegate
    weak var delegate: ViewControllerDelegate?

    //Datasource
    let dataSource = MatchDetailDataSource()
    
    //Contain to show
    var selectedContent: MatchDetailContent = .news
    
    //State
    var state: ViewControllerState = .loading
    
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
    
    //Header
    let headerView = MatchDetailHeader()
    
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
        
        self.state = state
        
    }
    
    func changeContentMatchDetail(content: MatchDetailContent) {
        self.selectedContent = content
    }
    
    func getData() {
        
        if state == .offline {
            return
        }
        
       
        getRelatedArticelData(matchID: self.dataSource.headerData?.matchID)
        getCompetitionRankingData(competitionID: self.dataSource.headerData?.competitionID)
        
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
        addSubviewsLayout()
        
        self.getData()

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
       
        self.title = dataSource.headerData?.competition
  
    }
    
    //MARK: GET, Load Data Functions
    
    func loadHeaderData(scoreBoard: HomeScoreBoardModel) {
        
        self.headerView.loadData(scoreBoard: scoreBoard)
        
    }
    
    func getRelatedArticelData(matchID: Int?) {
        
        guard let matchID = matchID else {
            return
        }
        
        QueryService.sharedService.get(ContentAPITarget.match(id: String(matchID), start: 0, size: 20)) {
            
            [unowned self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            switch result {
                
            case .success(let res):
                
                if let contents = res.data?.contents {
                    
                    var articelArray: [HomeArticleModel] = []
                    for i in contents {
                        
                        articelArray.append(HomeArticleModel(contentID: String(i.contentID),
                                                             avatar: i.avatar,
                                                             title: i.title,
                                                             publisherLogo: i.publisherLogo,
                                                             date: i.date))
                        
                    }
    
                    //changed vc state
                    if state == .loading {
                        
                        self.state = .loaded
                        
                    }
                    // add data to datasource
                    self.dataSource.articleData.append(contentsOf: articelArray)
                    
                }
                
            
            case .failure(let err):
                
                print("Error: \(err)")
               
            }
        }
    }
    
    func getCompetitionRankingData(competitionID: Int?) {
        
        guard let competitionID = competitionID else {
            return
        }
        
        QueryService.sharedService.get(CompetitionAPITarget.standing(id: String(competitionID))) {
            [unowned self]
            (result: Result<ResponseModel<CompetitionStandingModel>, Error>) in
            var rankingArray: [RankingModel] = []
            
            switch result {
                
            case .success(let res):
                
                if let contents = res.data?.soccerStandings {
                    
                    
                    for i in contents {
                        
                        rankingArray.append(RankingModel(teamName: i.teamName,
                                                         totalStat: i.total,
                                                         homeStat: i.home,
                                                         awayStat: i.away))
                        
                    }
    
                }
                
            case .failure(let err):
                
                print("Error: \(err)")
          
            }
            // add data to datasource
            self.dataSource.rankingData.append(contentsOf: rankingArray)
        }
        
    }
}


//MARK: Datasource Extension
extension MatchDetailController: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if state == .loading || state == .error {
            
            return 1
            
        } else {
            
            //news articel content
            if selectedContent == .news {
                return dataSource.articelSize
            }
            
            return dataSource.rankingSize
        }
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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

        if selectedContent == .news {
            
            let articelDetailVC = ArticelDetailController()
            
            self.delegate = articelDetailVC
            self.delegate?.passContentID(contentID: dataSource.articleData[indexPath.row].contentID)
            self.delegate?.passPublisherLogo(url: dataSource.articleData[indexPath.row].publisherLogo)
            
            navigationController?.pushViewController(articelDetailVC, animated: true)
            
        }
     
    }

}

//MARK: Delegate Flow Layout extension
extension MatchDetailController: UICollectionViewDelegateFlowLayout {
    
    //Cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
    
        if state == .loading || state == .error {
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
        } else {
            
            //news articel content
            if selectedContent == .news {
                return CGSize(width: totalWidth,
                              height: totalHeight/7)
            } else {
                //ranking content
                return CGSize(width: totalWidth ,
                              height: collectionView.bounds.height/15)
            }
            
        }
        
    }
    
    //Line spaceing between cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if selectedContent == .news {
            
            return 20
            
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


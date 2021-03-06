//
//  TeamDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 12/07/2022.
//

import UIKit

class TeamDetailController: UIViewController, DataSoureDelegate {
    
    //status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
    // Datasource
    let dataSource = TeamDetailDataSource()
    
    //Header
    let headerView = TeamDetailHeader()
    
    //Main CollectionView Layout
    var teamDetailLayout = UICollectionViewFlowLayout()
    
    //Main CollectionView
    var teamDetailCollection: UICollectionView = {
        

        //Custom CollectionView
        let teamDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        teamDetailCollection.backgroundColor = UIColor.white
        teamDetailCollection.contentInsetAdjustmentBehavior = .always
        //Cell
        teamDetailCollection.register(ArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        teamDetailCollection.register(RankingCell.self, forCellWithReuseIdentifier: "RankingCell")
        teamDetailCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "LoadMoreCell")
        //Section
        teamDetailCollection.register(DetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TeamDetailSectionHeader")
      
        return teamDetailCollection
        
    }()
    
    
    //MARK: Delegation function
    func passHeaderData(teamInfo: TeamInfoData?) {
        
        guard let teamInfo = teamInfo else {
            return
        }
      
        dataSource.headerData = teamInfo
    
        headerView.loadData(teamName: teamInfo.teamName, teamLogo: teamInfo.teamLogo)
        
    }
    
    func changeContent(content: DetailContent) {
        dataSource.selectedContent = content
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.teamDetailCollection.reloadData()
            
        }
        
    }
    
    func changeState(state: ViewControllerState) {
        
        self.dataSource.state = state
        self.reloadData()
        
    }
    
    func getData() {
        
        dataSource.getRelatedArticelData(teamID: dataSource.headerData?.teamID)
        dataSource.getCompetitionRankingData(competitionID: dataSource.headerData?.compID)
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
        teamDetailCollection.dataSource = self
        teamDetailCollection.delegate = self
        
        teamDetailCollection.collectionViewLayout = teamDetailLayout
        
        //MARK: Add layout and Subviews
        
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.view.bounds.width,
                                  height: self.view.bounds.height/5)
      
        view.addSubview(teamDetailCollection)
        view.addSubview(headerView)
        self.view = view
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .black
        
        teamDetailLayout.sectionInsetReference = .fromSafeArea
        teamDetailLayout.sectionHeadersPinToVisibleBounds = true
       
        addSubviewsLayout()
        
        //Getdata
        if dataSource.state == .loading {
            self.getData()
        }
      
    }
    
    //MARK: viewWillAppear() state
    override func viewWillAppear( _ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Custom Navigation Bars
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let startColor = UIColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1).cgColor
        let middleColor = UIColor(red: 0.05, green: 0.39, blue: 0.59, alpha: 1).cgColor
        
        navigationController?.navigationBar.setTitleAttribute(color: .white,
                                                              font: UIFont.boldSystemFont(ofSize: 20))
        navigationController?.navigationBar.setGradientBackground(colors: [startColor,middleColor])
        
        //Back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    //MARK: Add subviews layout
    func addSubviewsLayout() {
    
        teamDetailCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            teamDetailCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: headerView.bounds.height),
            teamDetailCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            teamDetailCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            teamDetailCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
        
    }
    
   
}

//MARK: Datasource Extension
extension TeamDetailController: UICollectionViewDataSource {
    
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
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TeamDetailSectionHeader", for: indexPath) as! DetailSectionHeader
            sectionHeader.delegate = self
            return sectionHeader
            
            
       } else {
           
            return UICollectionReusableView()
           
       }
    }
}

//MARK: Delegate Extension
extension TeamDetailController: UICollectionViewDelegate {
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
extension TeamDetailController: UICollectionViewDelegateFlowLayout {
    
    //Cell Size
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
                return CGSize(width: totalWidth,
                              height: collectionView.bounds.height/15)
            }
            
        case .error:
            return CGSize(width: totalWidth,
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

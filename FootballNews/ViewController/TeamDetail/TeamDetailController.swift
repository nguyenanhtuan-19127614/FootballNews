//
//  TeamDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 12/07/2022.
//

import UIKit

struct TeamInfoData {
    
    var teamID: Int
    var teamName: String
    var teamLogo: String
}

class TeamDetailController: UIViewController, DataSoureDelegate {
    
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
//        teamDetailCollection.register(MatchDetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MatchDetailSectionHeader")
//      
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
    
    func changeContentTeamDetail(content: TeamDetailContent) {
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
        ViewControllerRouter.shared.setUpNavigationController(self.navigationController)
        addSubviewsLayout()
      
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
    
    //MARK: Custom Layout
    override func viewDidLayoutSubviews() {
        
        teamDetailLayout.sectionInsetReference = .fromSafeArea
        teamDetailLayout.sectionHeadersPinToVisibleBounds = true
       
    }
}

//MARK: Datasource Extension
extension TeamDetailController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreIndicatorCell
        
        indicatorCell.indicator.startAnimating()
        
        return indicatorCell
        
    }
    
}

//MARK: Delegate Extension
extension TeamDetailController: UICollectionViewDelegate {
    
}

//MARK: Delegate Flow Layout extension
extension TeamDetailController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
        let state = dataSource.state
        let selectedContent = dataSource.selectedContent
        
        switch state {
        case .loading:
            return CGSize(width: totalWidth,
                          height: totalHeight)
            
        case .loaded:
            return CGSize(width: totalWidth,
                          height: totalHeight)
            
        case .error:
            return CGSize(width: totalWidth,
                          height: totalHeight)
            
        case .offline:
            return CGSize(width: totalWidth,
                          height: totalHeight)
            
        }
        
    }
    
    
}

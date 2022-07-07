//
//  MatchDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 06/07/2022.
//

import Foundation
import UIKit

class MatchDetailController: UIViewController, ViewControllerDelegate, DataSoureDelegate {
    
    //Delegate
    weak var delegate: ViewControllerDelegate?

    //Datasource
    let dataSource = MatchDetailDataSource()
    
    //Main CollectionView Layout
    var matchDetailLayout = UICollectionViewFlowLayout()
    
    //State
    var state: ViewControllerState = .loading
    
    //Main CollectionView
    var matchDetailCollection: UICollectionView = {
        
        //Custom CollectionView
        let matchDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        matchDetailCollection.backgroundColor = UIColor.white
        matchDetailCollection.contentInsetAdjustmentBehavior = .always
        
        //Register data for CollectionView
        matchDetailCollection.register(HomeArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        matchDetailCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "LoadMoreCell")
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
        print("HeaderData: \(scoreBoard)")
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.matchDetailCollection.reloadData()
            
        }
        
    }
    
    func changeState(state: ViewControllerState) {
        
        self.state = state
        
    }
    
    func getData() {
        
        if state == .offline {
            return
        }
        
        self.getRelatedArticelData(matchID: self.dataSource.headerData?.matchID)
  
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
        
        addSubviewsLayout()
        view.addSubview(matchDetailCollection)
        view.addSubview(headerView)
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.getData()
        
    }
    
    //MARK: Add subviews layout
    func addSubviewsLayout() {
        
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.view.bounds.width,
                                  height: self.view.bounds.height/5)
        
        matchDetailCollection.frame = CGRect(x: 0,
                                             y: headerView.frame.maxY,
                                             width: self.view.bounds.width,
                                             height: self.view.bounds.height - headerView.bounds.height - 10)
    
        
    }
    
    //MARK: Custom Layout
    override func viewDidLayoutSubviews() {
        
        matchDetailLayout.sectionInsetReference = .fromSafeArea
        matchDetailLayout.minimumLineSpacing = 20
       
    }
    
    //MARK: viewWillAppear() state
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //Custom Navigation Bars
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if #available(iOS 13.0, *) {
            let startColor = CGColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1)
            let middleColor = CGColor(red: 0.05, green: 0.39, blue: 0.59, alpha: 1)
            
            navigationController?.navigationBar.setGradientBackground(colors: [startColor,middleColor])
                           
        }
       
        //navigationController?.navigationBar.setImageBackground(image: nil)
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
                    
                    // add data to datasource
                    
                    //changed vc state
                    if state == .loading {
                        
                        self.state = .loaded
                        
                    }
                    
                    self.dataSource.articleData.append(contentsOf: articelArray)
                    
                }
                
            case .failure(let err):
                print("Error: \(err)")
                
            }
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
            
            return dataSource.articelSize
            
        }
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard state == .loaded else {
            
            let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreIndicatorCell
            
            indicatorCell.indicator.startAnimating()
            return indicatorCell
            
        }
        
        let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
        
        articelCell.backgroundColor = UIColor.white
        articelCell.loadData(inputData: self.dataSource.articleData[indexPath.row])
        
        return articelCell
        
    }
}

//MARK: Delegate Extension
extension MatchDetailController: UICollectionViewDelegate {
    
    //Tap Event
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let articelDetailVC = ArticelDetailController()
        
        self.delegate = articelDetailVC
        self.delegate?.passContentID(contentID: dataSource.articleData[indexPath.row].contentID)
        self.delegate?.passPublisherLogo(url: dataSource.articleData[indexPath.row].publisherLogo)
        
        navigationController?.pushViewController(articelDetailVC, animated: true)
        
    }

}

//MARK: Delegate Flow Layout extension
extension MatchDetailController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
    
        if state == .loading || state == .error {
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
        } else {
            
            return CGSize(width: totalWidth,
                          height: totalHeight/7)
            
        }
        
    }
    
}


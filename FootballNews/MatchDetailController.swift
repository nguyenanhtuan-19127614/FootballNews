//
//  MatchDetailController.swift
//  FootballNews
//
//  Created by LAP13606 on 06/07/2022.
//

import Foundation
import UIKit

class MatchDetailController: UIViewController, ViewControllerDelegate {
    
    //Datasource
    let dataSource = MatchDetailDataSource()
    
    //Main CollectionView Layout
    var matchDetailLayout = UICollectionViewFlowLayout()
    
    //Main CollectionView
    var matchDetailCollection: UICollectionView = {
        
        //Custom CollectionView
        let matchDetailCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        matchDetailCollection.backgroundColor = UIColor.white
        matchDetailCollection.contentInsetAdjustmentBehavior = .always
        
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
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        
        //MARK: Create customView
        let view = UIView()
        view.backgroundColor = .white
        
        //MARK: Collection View
        
        matchDetailCollection.dataSource = self
        matchDetailCollection.delegate = self
        
        matchDetailCollection.collectionViewLayout = matchDetailLayout
        
        //MARK: Add layout and Subviews
        
        addSubviewsLayout()
        //view.addSubview(matchDetailCollection)
     
        view.addSubview(headerView)
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
       
    }
    
    //MARK: Add subviews layout
    func addSubviewsLayout() {
        
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.view.bounds.width,
                                  height: self.view.bounds.height/5)
        
        
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
}


//MARK: Datasource Extension
extension MatchDetailController: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreIndicatorCell
        
        indicatorCell.indicator.startAnimating()
        return indicatorCell
        
    }
}

//MARK: Delegate Extension
extension MatchDetailController: UICollectionViewDelegate {
    
    //Tap Event
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

           
    }
    
    
    
}

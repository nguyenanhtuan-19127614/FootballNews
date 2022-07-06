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
    
    //MARK: Delegation Function
    func passHeaderData(scoreBoard: HomeScoreBoardModel?) {
        
        guard let scoreBoard = scoreBoard else {
            return
        }
        dataSource.headerData = scoreBoard
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
        
        //view.addSubview(matchDetailCollection)
        
       
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
    }
    
    
    //MARK: viewWillAppear() state
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //Custom Navigation Bars
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        if #available(iOS 13.0, *) {
//            let startColor = CGColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1)
//            let middleColor = CGColor(red: 0.05, green: 0.39, blue: 0.59, alpha: 1)
//            let endColor = CGColor(red: 0.04, green: 0.31, blue: 0.58, alpha: 1)
//            navigationController?.navigationBar.setTitleAndGradientBackground(colors: [startColor],
//
//        }
       
        navigationController?.navigationBar.setImageBackground(image: nil)
        self.title = dataSource.headerData?.competition
        
       
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

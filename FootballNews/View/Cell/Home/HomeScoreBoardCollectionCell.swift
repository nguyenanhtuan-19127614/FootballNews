//
//  HomeScoreBoardCollectionCell.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import UIKit

//MARK: Cell that contain collectionView of HomeScoreBoardCell
class HomeScoreBoardCollectionCell: UICollectionViewCell {
    
    var scoreBoardData: [HomeScoreBoardData] = []
    var scoreBoardCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Add subviews to cell
    func addViews() {
        
        let scoreBoardLayout = UICollectionViewFlowLayout()
        scoreBoardLayout.itemSize = CGSize(width: self.bounds.width/1.5,
                                           height: self.bounds.height)
        scoreBoardLayout.minimumLineSpacing = 20
        scoreBoardLayout.scrollDirection = .horizontal
        
        scoreBoardCollection = UICollectionView(frame: .zero, collectionViewLayout: scoreBoardLayout)
        
        scoreBoardCollection.showsHorizontalScrollIndicator = false
        
        scoreBoardCollection.register(HomeScoreBoardCell.self, forCellWithReuseIdentifier: "HomeScoreBoardCell")
        scoreBoardCollection.dataSource = self
        scoreBoardCollection.delegate = self
        
        addSubview(scoreBoardCollection)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
       
        self.scoreBoardCollection.frame = CGRect(x: self.frame.minX,
                                                 y: 20,
                                                 width: self.bounds.width,
                                                 height: self.bounds.height)
   
    }
    
    //MARK: Load data to cell
    func loadData(inputData: [HomeScoreBoardData]) {
        
        self.scoreBoardData = inputData
        DispatchQueue.main.async {
            
            self.scoreBoardCollection.reloadData()
            
        }
        
    }
    
}

//MARK: Datasource Extension

extension HomeScoreBoardCollectionCell: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return scoreBoardData.count
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let scoreBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScoreBoardCell", for: indexPath) as! HomeScoreBoardCell
        
        scoreBoardCell.backgroundColor = UIColor.white
        scoreBoardCell.loadData(inputData: scoreBoardData[indexPath.row])
        
        return scoreBoardCell
        
    }

}

//MARK: Delegate Extension
extension HomeScoreBoardCollectionCell: UICollectionViewDelegate {
    
    //Tap Event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("User tapped on item \(indexPath.row)")
        
    }
    
}

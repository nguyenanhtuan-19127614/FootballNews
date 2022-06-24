//
//  HomeCompetitionCollectionCell.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import UIKit

//MARK: Cell that contain collectionView of HomeCompetitionCell
class HomeCompetitionCollectionCell: UICollectionViewCell {
    
    var competitionData: [HomeCompetitionData] = []
    var competitionCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        
        let competitionLayout = UICollectionViewFlowLayout()
        competitionLayout.itemSize = CGSize(width: self.bounds.width/4,
                                            height: self.bounds.height)
        competitionLayout.minimumLineSpacing = 20
        competitionLayout.scrollDirection = .horizontal
        
        competitionCollection = UICollectionView(frame: .zero, collectionViewLayout: competitionLayout)
        competitionCollection.showsHorizontalScrollIndicator = false
        
        competitionCollection.register(HomeCompetitionCell.self, forCellWithReuseIdentifier: "HomeCompetitionCell")
        competitionCollection.dataSource = self
        competitionCollection.delegate = self
        
        addSubview(competitionCollection)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
      
        self.competitionCollection.frame = CGRect(x: self.frame.minX,
                                             y: 0,
                                             width: self.bounds.width,
                                             height: self.bounds.height)
        
    }
    
    //MARK: Load data to cell
    func loadData(inputData: [HomeCompetitionData]) {
        
        self.competitionData = inputData
        DispatchQueue.main.async {
            
            self.competitionCollection.reloadData()
            
        }
        
    }
    
    

}

//MARK: Datasource Extension

extension HomeCompetitionCollectionCell: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return competitionData.count
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let competitionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCompetitionCell", for: indexPath) as! HomeCompetitionCell
        
        competitionCell.backgroundColor = UIColor.white
        competitionCell.loadData(inputData: competitionData[indexPath.row])
        
        return competitionCell
        
    }

}

//MARK: Delegate Extension
extension HomeCompetitionCollectionCell: UICollectionViewDelegate {
    
    //Tap Event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("User tapped on item \(indexPath.row)")
        
    }
    
}

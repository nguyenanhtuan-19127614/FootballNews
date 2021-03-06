//
//  HomeScoreBoardCollectionCell.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import UIKit

//MARK: Cell that contain collectionView of HomeScoreBoardCell
class HomeScoreBoardCollectionCell: UICollectionViewCell {
    
    weak var delegate: HomeViewController?
    
    var scoreBoardData: [HomeScoreBoardModel] = []
    var scoreBoardCollection: UICollectionView = {
        
        let scoreBoardLayout = UICollectionViewFlowLayout()
        scoreBoardLayout.scrollDirection = .horizontal
        
        let scoreBoardCollection = UICollectionView(frame: .zero, collectionViewLayout: scoreBoardLayout)
        
        scoreBoardCollection.showsHorizontalScrollIndicator = false
        
        scoreBoardCollection.register(HomeScoreBoardCell.self, forCellWithReuseIdentifier: "HomeScoreBoardCell")
        
        return scoreBoardCollection
        
    }()
    
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
        
       
        scoreBoardCollection.dataSource = self
        scoreBoardCollection.delegate = self

        addSubview(scoreBoardCollection)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        scoreBoardCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreBoardCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            scoreBoardCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            scoreBoardCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            scoreBoardCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
        ])

     
    }
    
    //MARK: Load data to cell
    func loadData(inputData: [HomeScoreBoardModel]) {
        
        self.scoreBoardData = inputData
        self.scoreBoardCollection.reloadData()
        
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
        
        delegate?.scoreBoardClick(index: indexPath.row)
          
    }
    
}


//MARK: Delegate Flow Layout extension
extension HomeScoreBoardCollectionCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: scoreBoardCollection.bounds.width/1.5,
                      height: scoreBoardCollection.bounds.height)
        
    }
    
}

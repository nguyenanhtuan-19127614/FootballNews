//
//  HomeCompetitionCollectionCell.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import UIKit

//MARK: Cell that contain collectionView of HomeCompetitionCell
class HomeCompetitionCollectionCell: UICollectionViewCell {
    
    weak var delegate: HomeViewController?
    
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "GIẢI ĐẤU"
        label.font = UIFont.boldSystemFont(ofSize: 18)
    
        label.textColor = UIColor(red: 0.694, green: 0.694, blue: 0.694, alpha: 1)
        
        return label
        
    }()
    
    var competitionData: [HomeCompetitionModel] = []
    var competitionCollection: UICollectionView = {
    
        let competitionLayout = UICollectionViewFlowLayout()
        competitionLayout.minimumLineSpacing = 5
        competitionLayout.scrollDirection = .horizontal
        
        let competitionCollection = UICollectionView(frame: .zero, collectionViewLayout: competitionLayout)
        competitionCollection.showsHorizontalScrollIndicator = false
        
        competitionCollection.register(HomeCompetitionCell.self, forCellWithReuseIdentifier: "HomeCompetitionCell")
        
        return competitionCollection
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
        
        competitionCollection.dataSource = self
        competitionCollection.delegate = self
        
        addSubview(competitionCollection)
        addSubview(nameLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
  
        self.nameLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: self.bounds.width,
                                      height: self.bounds.height / 5)
        self.nameLabel.sizeToFit()
        self.nameLabel.frame.size.height = self.bounds.height / 5
        
        self.competitionCollection.frame = CGRect(x: 0,
                                                  y: self.nameLabel.frame.maxY,
                                                  width: self.bounds.width ,
                                                  height: self.bounds.height * 4 / 5 )
       
    }
    
    //MARK: Load data to cell
    func loadData(inputData: [HomeCompetitionModel]) {
        
        self.competitionData = inputData
        self.competitionCollection.reloadData()
        
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
        
        delegate?.competitionBoardClick(index: indexPath.row)
        
    }
    
}

//MARK: Delegate Flow Layout extension
extension HomeCompetitionCollectionCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: competitionCollection.bounds.width/3,
                      height: competitionCollection.bounds.height)
    }
    
}

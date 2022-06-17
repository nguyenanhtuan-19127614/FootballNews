//
//  HomeCompetitionCell.swift
//  FootballNews
//
//  Created by LAP13606 on 17/06/2022.
//

import UIKit

//MARK: Home - Competition Cell
class HomeCompetitionCell: UICollectionViewCell {
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //add sub views
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define Sub-views
    
    let competitionLogo: UIImageView = {
        
        let imgView = UIImageView()
        
        return imgView
        
    }()
    
    let competitionName: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        
        return label
         
    }()
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(competitionLogo)
        addSubview(competitionName)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        competitionLogo.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.bounds.width,
                                       height: self.bounds.height * 2 / 3)
        
        competitionName.frame = CGRect(x: 0,
                                       y: competitionLogo.frame.maxY + 10,
                                       width: self.bounds.width,
                                       height: self.bounds.height - competitionLogo.bounds.height )
        
    }
    
    //MARK: Load data to cell
    func loadData(inputData: HomeCompetitionData) {
        
        //Subviews that don't need downloading
        self.competitionName.text = inputData.name
    
        //Subviews that need downloading
        self.competitionLogo.loadImage(url: inputData.logo)
        
    }
}

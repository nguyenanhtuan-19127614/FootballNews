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
        imgView.contentMode = .scaleAspectFit
    
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
        
        competitionLogo.translatesAutoresizingMaskIntoConstraints = false
        competitionName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            competitionLogo.widthAnchor.constraint(equalToConstant: self.bounds.width),
            competitionLogo.heightAnchor.constraint(equalToConstant: self.bounds.height * 2 / 3),
            competitionLogo.topAnchor.constraint(equalTo: self.topAnchor),
        
            competitionName.topAnchor.constraint(equalTo: competitionLogo.bottomAnchor),
            competitionName.widthAnchor.constraint(equalToConstant: self.bounds.width),
            competitionName.heightAnchor.constraint(equalToConstant: self.bounds.height * 1 / 3)
            
        ])
        

        //competitionName.sizeToFit()
        //competitionName.frame.size.width = self.bounds.width
        
    }
    
    //MARK: Load data to cell
    func loadData(inputData: HomeCompetitionModel) {
        //Subviews that don't need downloading
        self.competitionName.text = inputData.name
    
        //Subviews that need downloading
        self.competitionLogo.loadImageFromUrl(url: inputData.logo)
        
    }
}

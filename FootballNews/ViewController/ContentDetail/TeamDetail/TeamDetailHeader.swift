//
//  TeamDetailHeader.swift
//  FootballNews
//
//  Created by LAP13606 on 13/07/2022.
//

import UIKit

class TeamDetailHeader: UIView {
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //gradient background
        let startColor = UIColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1).cgColor
        let endColor = UIColor(red: 0.04, green: 0.31, blue: 0.58, alpha: 1).cgColor
        let colorsList = [startColor,endColor]
        
        if let gradientImage = UIImage().createGradientImage(colors: colorsList, frame: self.frame) {
            self.layer.contents = gradientImage.cgImage

        }
        //add sub views
        addSubViews()
        addLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Define Sub-views
    let teamLogo: UIImageView = {
        
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
    
        return imgView
        
    }()
    
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
    
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(teamLogo)
        addSubview(nameLabel)
        
    }
    
    //MARK: Add layout for subviews
    func addLayout() {
        
        teamLogo.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
       
            teamLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            teamLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            teamLogo.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2),
            teamLogo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2),
        
            nameLabel.topAnchor.constraint(equalTo: teamLogo.bottomAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor)

        ])
    }
    
    //MARK: Load data
    func loadData(teamName: String, teamLogo: String) {
   
        //Subviews that don't need downloading
        self.nameLabel.text = teamName
    
        //Subviews that need downloading
        self.teamLogo.loadImageFromUrl(url: teamLogo)
    
    }
}

//
//  CompetitionDetailHeader.swift
//  FootballNews
//
//  Created by LAP13606 on 12/07/2022.
//

import Foundation
import UIKit

class CompetitionDetailHeader: UIView {
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //gradient background
        if #available(iOS 13.0, *) {
            
            let startColor = CGColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1)
            let endColor = CGColor(red: 0.04, green: 0.31, blue: 0.58, alpha: 1)
            let colorsList = [startColor,endColor]
            
            if let gradientImage = UIImage().createGradientImage(colors: colorsList, frame: self.frame) {
                self.layer.contents = gradientImage.cgImage
    
            }
           

        }
        //add sub views
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Define Sub-views
    let compLogo: UIImageView = {
        
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.backgroundColor = .white
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
        
        addSubview(compLogo)
        addSubview(nameLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        compLogo.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
       
            compLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            compLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            compLogo.widthAnchor.constraint(equalToConstant: self.bounds.height/2),
            compLogo.heightAnchor.constraint(equalToConstant: self.bounds.height/2),
            
            nameLabel.topAnchor.constraint(equalTo: compLogo.bottomAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: self.bounds.width)

        ])
     
       
        //Round border
        compLogo.layoutIfNeeded()
        compLogo.layer.cornerRadius = compLogo.bounds.width/2
    }
    
    //MARK: Load data
    func loadData(compName: String, compLogo: String) {
   
        //Subviews that don't need downloading
        self.nameLabel.text = compName
    
        //Subviews that need downloading
        self.compLogo.loadImageFromUrl(url: compLogo)
    
    }
}

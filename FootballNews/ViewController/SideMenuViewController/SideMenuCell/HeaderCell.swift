//
//  IconHolder.swift
//  FootballNews
//
//  Created by LAP13606 on 19/07/2022.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    //MARK: Overide Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
//        if let background = UIImage(named: "IconHolder") {
//
//            self.backgroundColor = UIColor(patternImage: background)
//
//        }
        
        self.addBottomBorder(with: .gray, andWidth: 0.5)

        addSubViews()
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define SubViews
    
    let iconApp: UIImageView = {
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "IconApp")
      
        return imgView
        
    }()
    
    func addSubViews() {
        
        self.addSubview(iconApp)
   
    }
    
    override func layoutSubviews() {
        
        let startColor = UIColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1).cgColor
        let middleColor = UIColor(red: 0.05, green: 0.39, blue: 0.59, alpha: 1).cgColor
        let endColor = UIColor(red: 0.04, green: 0.31, blue: 0.58, alpha: 1).cgColor
        
        if let gradient = UIImage().createGradientImage(colors: [startColor,middleColor,endColor], frame: self.frame) {
            
            self.backgroundColor = UIColor(patternImage: gradient)
            
        }
        
     
    }
    
    func addLayout() {
        
        iconApp.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            iconApp.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier: 1/2),
            iconApp.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2),
            iconApp.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconApp.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    
        ])
       
    }
    
}

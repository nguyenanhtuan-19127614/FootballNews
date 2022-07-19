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
        
        if let background = UIImage(named: "IconHolder") {
            self.backgroundColor = UIColor(patternImage: background)
        }

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

//
//  MatchDetailHeader.swift
//  FootballNews
//
//  Created by LAP13606 on 06/07/2022.
//

import UIKit

class MatchDetailHeader: UICollectionReusableView {
    
    
    
}

class TeamView: UIView {

    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      
    }
    
    //MARK: Define SubViews
    
    let logoTeam: UIImageView = {
        
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFit
        
        return imgView
        
    }()
    
    let teamName: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(logoTeam)
        addSubview(teamName)
       
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    
}

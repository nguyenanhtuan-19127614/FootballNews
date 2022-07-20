//
//  SideMenuCell.swift
//  FootballNews
//
//  Created by LAP13606 on 19/07/2022.
//

import UIKit

class SideMenuCell: UICollectionViewCell {
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.addBottomBorder(with: .lightGray, andWidth: 0.5)
        
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: Define subview
    let menuIcon: UIImageView = {
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        return imgView
        
    }()
    
    let menuLabel: PaddingLabel = {
        
        let label = PaddingLabel()
        label.setupPadding(top: 0, bottom: 0, left: 30, right: 0)
        label.font = label.font.withSize(20)
     
        return label
        
    }()
    
    //Add Subviews
    func addSubViews() {
        
        self.addSubview(menuIcon)
        self.addSubview(menuLabel)
        
    }
    
    //Layout subview
    override func layoutSubviews() {
        
        menuIcon.frame = CGRect(x: 0,
                                y: self.bounds.height/4,
                                width: self.bounds.height/2,
                                height: self.bounds.height/2)
        
        menuLabel.frame = CGRect(x: menuIcon.frame.maxX,
                                 y: 0,
                                 width: self.bounds.width - menuIcon.bounds.width,
                                 height: self.bounds.height)
        
    }
    
    //Load Data
    
    func loadData(data: SideMenuModel) {
        
        menuIcon.image = data.icon
        menuLabel.text = data.label
        
    }
    
}

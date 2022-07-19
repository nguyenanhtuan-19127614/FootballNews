//
//  HeaderSection.swift
//  FootballNews
//
//  Created by LAP13606 on 19/07/2022.
//

import UIKit

class SideMenuCellHeader: UICollectionReusableView {
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addBottomBorder(with: .lightGray, andWidth: 1)
        //add sub views
        addSubViews()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Define Sub-views

    let headerLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Tin tức"
        label.font = UIFont.boldSystemFont(ofSize: 25)
       
        return label
        
    }()
    
 
    
    
    //MARK: Add subviews to cell
    func addSubViews() {
    
        addSubview(headerLabel)
        
    }
    
    //MARK: Add layout subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        headerLabel.frame = CGRect(x: 0,
                                   y: 0,
                                   width: self.bounds.width,
                                   height: self.bounds.height)
      

    }
 
}

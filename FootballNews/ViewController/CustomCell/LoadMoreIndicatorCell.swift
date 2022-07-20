//
//  LoadMoreIndicatorCell.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import UIKit

class LoadMoreIndicatorCell: UICollectionViewCell {
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        addLayout()
    }
    
    var indicator : UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView()
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        return indicator
        
    }()
    
    func setup(){
        
        contentView.addSubview(indicator)

    }
    
    func addLayout() {
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    
        ])
        
    }
}

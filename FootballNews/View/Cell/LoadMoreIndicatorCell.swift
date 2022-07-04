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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var indicator : UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView()
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        return indicator
        
    }()
    
    func setup(){
        
        contentView.addSubview(indicator)

    }
    
    override func layoutSubviews() {
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    
        ])
        
    }
}

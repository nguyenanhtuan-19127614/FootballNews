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
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
        
    }()
    
    func setup(){
        
        contentView.addSubview(indicator)

    }
    
    override func layoutSubviews() {
        
        print("LoadMoreCellWidt: \(self.bounds.width)")
      
        NSLayoutConstraint.activate([
            
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicator.widthAnchor.constraint(equalToConstant: self.bounds.width / 5),
            indicator.heightAnchor.constraint(equalToConstant: self.bounds.height)
        ])
    }
}

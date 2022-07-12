//
//  SeparateCell.swift
//  FootballNews
//
//  Created by LAP13606 on 12/07/2022.
//

import UIKit

class SeparateCell: UICollectionViewCell {
    
    let grayColor: UIColor = .lightGray.withAlphaComponent(0.2)
    //MARK: Override Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = grayColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

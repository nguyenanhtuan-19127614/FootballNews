//
//  SeparateCell.swift
//  FootballNews
//
//  Created by LAP13606 on 12/07/2022.
//

import UIKit

class SeparateCell: UICollectionViewCell {
    
    var grayColor: UIColor = UIColor(red: 0.937, green: 0.933, blue: 0.957, alpha: 1)
    //MARK: Override Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = grayColor
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

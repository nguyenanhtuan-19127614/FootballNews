//
//  ArticelDetailBodyTextCell.swift
//  FootballNews
//
//  Created by LAP13606 on 30/06/2022.
//

import UIKit


//MARK: Articel Detail Body Cell that have type "text"
class ArticelDetailBodyTextCell: UICollectionViewCell {
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubViews()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define Subviews
    let contentLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addSubViews() {

        addSubview(contentLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        contentLabel.frame = CGRect (x: 15,
                                     y: 0,
                                     width: self.bounds.width - 30,
                                     height: 0)
        contentLabel.sizeToFit()
       
    }
    
    //MARK: Load Data
    func loadData(_ inputData: String, subtype: String?) {
        
        contentLabel.renderHTMLAtribute(from: inputData,
                                        size: 22,
                                        lineSpacing: 5)
        
        guard subtype != nil else {
            return
        }
         
        if subtype == "media-caption" {
            
            contentLabel.font = contentLabel.font.withSize(18)
            contentLabel.textAlignment = .center
        

        }
    }
}

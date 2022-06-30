//
//  ArticelDetailBodyCell.swift
//  FootballNews
//
//  Created by LAP13606 on 21/06/2022.
//

import UIKit
fileprivate let paddingLeft = 15.0

//MARK: Articel Detail Body Cell that have type "text"

class ArticelDetailTextCell: UICollectionViewCell {
    
    let fontLabel: UIFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 16)
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
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
    func addViews() {

        addSubview(contentLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        contentLabel.frame = CGRect (x: paddingLeft,
                                     y: 0,
                                     width: self.bounds.width - 30,
                                     height: 0)
        contentLabel.sizeToFit()
        contentLabel.frame.size.width = self.bounds.width - 30
        
    }
    
    //MARK: Calculate height of cell base on subviews
    func calculateHeight() -> CGFloat {
        
        var height: CGFloat = 0
        height += contentLabel.calculateHeight(cellWidth: self.bounds.width)
        
        return height
    }
    
    //MARK: Load Data
    func loadData(_ inputData: String, subtype: String?) {
        
        contentLabel.renderHTMLAtribute(from: inputData, size: 22)
        
        guard subtype != nil else {
            return
        }
         
        if subtype == "media-caption" {
        
            contentLabel.font = contentLabel.font.withSize(18)
            contentLabel.textAlignment = .center

        }
    
    }
}

//MARK: Articel Detail Body Cell that have type "image"

class ArticelDetailImageCell: UICollectionViewCell {
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define Subviews
    let contentImage: UIImageView = {
        
        let imgView = UIImageView()
    
        return imgView
        
    }()
    
    //MARK: Add subviews to cell
    func addViews() {
        
        addSubview(contentImage)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        contentImage.frame = CGRect (x: paddingLeft,
                                     y: 0,
                                     width: self.bounds.width - (2 * paddingLeft),
                                     height: self.bounds.height)
       
   
   
    }

    //MARK: Load Data
    func loadData(_ inputData: String) {
        
        contentImage.loadImageFromUrl(url: inputData)
        
    }
}

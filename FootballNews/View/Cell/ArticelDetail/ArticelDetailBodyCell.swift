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
    

    var dynamicHeight: CGFloat = 0
    let fontLabel: UIFont = UIFont(name: "Helvetica", size: 16.0) ?? UIFont.systemFont(ofSize: 16)
    
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
    
    func calculateHeight(text:String , cellWidth : CGFloat, font: UIFont) -> CGFloat
    {
        let font = font
        let label = UILabel()
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: cellWidth,
                             height: 0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height

    }
    //MARK: Add subviews to cell
    func addViews() {

        print("Height1: \(contentLabel.bounds.height)" )
        addSubview(contentLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        contentLabel.frame = CGRect (x: paddingLeft,
                                     y: 0,
                                     width: self.bounds.width - 20,
                                     height: 0)
        contentLabel.sizeToFit()
     
        
//        NSLayoutConstraint.activate([
//
//            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: paddingLeft),
//            contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -paddingLeft),
//            contentLabel.topAnchor.constraint(equalTo: self.topAnchor , constant: paddingLeft),
//            contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: 0),
//
//
//        ])
        
    }
    
    
    
    //MARK: Load Data
    func loadData(_ inputData: String) {
        
        contentLabel.text = inputData
        contentLabel.font = self.fontLabel
        
        dynamicHeight = calculateHeight(text: inputData,
                                       cellWidth: self.bounds.width - 20,
                                       font:self.fontLabel)
        
        self.bounds.size.height = dynamicHeight

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
    
        contentImage.frame = CGRect (x: paddingLeft + 10,
                                     y: 10,
                                     width: self.bounds.width - paddingLeft - 30,
                                     height: self.bounds.height)
        
   
    }
    
    //MARK: Load Data
    func loadData(_ inputData: String) {
        
        contentImage.loadImage(url: inputData)
        
    }
}

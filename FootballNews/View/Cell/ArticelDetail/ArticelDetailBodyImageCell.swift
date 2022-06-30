//
//  ArticelDetailBodyImageCell.swift
//  FootballNews
//
//  Created by LAP13606 on 30/06/2022.
//

import UIKit

fileprivate let paddingLeft = 15.0

//MARK: Articel Detail Body Cell that have type "image"
class ArticelDetailBodyImageCell: UICollectionViewCell {
    
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
        imgView.contentMode = .scaleAspectFit
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

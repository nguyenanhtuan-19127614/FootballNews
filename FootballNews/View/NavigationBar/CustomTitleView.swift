//
//  CustomTitleView.swift
//  FootballNews
//
//  Created by LAP13606 on 23/06/2022.
//

import UIKit

class CustomTitleView: UIImageView {
    
    //MARK: Overide Init
   
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define SubViews
    
    let titleImageView: UIImageView = {
        
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
        
    }()
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(titleImageView)
      
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        
        
        NSLayoutConstraint.activate([
            
            titleImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: self.bounds.width / 5),
            titleImageView.heightAnchor.constraint(equalToConstant: self.bounds.height / 2)
        
        ])
        
       
        
    }
    
    //MARK: Load data to cell
    
    func loadData(url: URL?) {
       
        guard let url = url else {
            return
        }

        titleImageView.loadImage(url: url.absoluteString)
        
    }
}

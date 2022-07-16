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
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define SubViews
    
    let titleImageView: UIImageView = {
        
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
       
        return imgView
        
    }()
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(titleImageView)
      
    }
    
    //MARK: Add layout for subviews
    func addLayout() {
        
        NSLayoutConstraint.activate([
            
            titleImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: self.frame.width),
            titleImageView.heightAnchor.constraint(equalToConstant: self.frame.height)
            
        ])
  
    }
   
    
    //MARK: Load data to cell
    
    func loadData(url: URL?) {
       
        guard let url = url else {
            return
        }

        titleImageView.loadImageFromUrl(url: url.absoluteString)
        
    }
    
    func loadData(image: UIImage?) {
        
        guard let image = image else {
            return
        }
        
        titleImageView.image = image
    }
}

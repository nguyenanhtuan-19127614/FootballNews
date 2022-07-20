//
//  UpComingViewController.swift
//  FootballNews
//
//  Created by LAP13606 on 18/07/2022.
//

import UIKit

class UpComingViewController: UIViewController {
    
    //status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var iconImg: UIImageView = {
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "IconApp")
        return imgView
        
    }()
    
    var label: UILabel = {
        
        let label = UILabel()
        label.text = "Chức năng sẽ được cập nhật sau!"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addSubViews()
        addLayout()
        
    }
    
    func addSubViews() {
        self.view.addSubview(iconImg)
        self.view.addSubview(label)
    }
    
    func addLayout() {
        
        iconImg.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            iconImg.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2),
            iconImg.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/6),
            iconImg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            iconImg.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            label.topAnchor.constraint(equalTo: iconImg.bottomAnchor, constant: 20),
            label.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            
        ])
    }
    
    
    
}

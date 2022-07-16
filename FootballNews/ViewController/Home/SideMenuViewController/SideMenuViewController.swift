//
//  SideMenuViewController.swift
//  FootballNews
//
//  Created by LAP13606 on 16/07/2022.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    var isShow = false
    
    let iconApp: UIImageView = {
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "IconApp")
        return imgView
        
    }()
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        addLayout()
        
    }
    
    func addSubviews() {
        
        
        self.view.addSubview(iconApp)
       
    }
    
    func addLayout() {
        
        iconApp.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            iconApp.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
            iconApp.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier: 1/2),
            iconApp.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/6),
            iconApp.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        ])
    }
    
   
    func show() {
        
        var frame = view.frame
        frame.origin.x = 0
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .transitionFlipFromLeft,
                       animations: {[unowned self] in
            self.view.frame = frame
        }, completion: nil)
       
        isShow = true
        
        
    }
    
    func hide() {
        
        var frame = view.frame
        frame.origin.x = -frame.size.width
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .transitionFlipFromRight,
                       animations: {[unowned self] in
            self.view.frame = frame
        }, completion: nil)
        
        isShow = false
    }
    
}

class AppInfoView: UIView {
    
    //MARK: Overide Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubViews()
//        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define SubViews
    
    let infoLabel: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    let versionLabel: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    let emailLabel: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    let phoneNumberLabel: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    func addSubViews() {
        
        self.addSubview(infoLabel)
        self.addSubview(versionLabel)
        self.addSubview(emailLabel)
        self.addSubview(phoneNumberLabel)
   
    }
    
}

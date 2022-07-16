//
//  SideMenuViewController.swift
//  FootballNews
//
//  Created by LAP13606 on 16/07/2022.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    var shadowColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.5)
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
        //self.view.addSubview(headerView)
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
        UIView.animate(withDuration: 0.5,
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
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .transitionFlipFromRight,
                       animations: {[unowned self] in
            self.view.frame = frame
        }, completion: nil)
        
        isShow = false
    }
    
}


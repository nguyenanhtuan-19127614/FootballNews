//
//  SideMenuViewController.swift
//  FootballNews
//
//  Created by LAP13606 on 16/07/2022.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    var isShow = false
    
    let iconAppHolder = IconHolder()

    let appInfo = AppInfoView()

  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        addLayout()
        
    }
    
    func addSubviews() {
        
        //self.view.addSubview(appInfo)
        self.view.addSubview(iconAppHolder)
       
    }
    
    func addLayout() {
        
        iconAppHolder.translatesAutoresizingMaskIntoConstraints = false
        appInfo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            iconAppHolder.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            iconAppHolder.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/6),
            iconAppHolder.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            iconAppHolder.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,
                                                   constant: self.view.bounds.height/4)
//
//            appInfo.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/5),
//            appInfo.widthAnchor.constraint(equalTo: self.view.widthAnchor),
//            appInfo.topAnchor.constraint(equalTo: iconAppHolder.bottomAnchor,constant: 20)
        
        ])
        
//        if let background = UIImage(named: "IconHolder") {
//
//            iconAppHolder.backgroundColor = UIColor(patternImage: background)
//        }
        
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = UIColor.lightGray.cgColor
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

class IconHolder: UIView {
    
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
    
    let iconApp: UIImageView = {
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "IconApp")
        imgView.addShadow(color: UIColor.gray.cgColor)
        return imgView
        
    }()
    
    func addSubViews() {
        
        self.addSubview(iconApp)
   
    }
    
    func addLayout() {
        
        iconApp.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            iconApp.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier: 1/2),
            iconApp.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2),
            iconApp.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconApp.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    
        ])
       
    }
    
}


class AppInfoView: UIView {
    
    //MARK: Overide Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define SubViews
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "THÔNG TIN"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
        
    }()
    
    let versionLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Phiên Bản: \(AppInfo.version.getValue())"
        label.font = label.font.withSize(18)
        label.numberOfLines = 0
        
        return label
        
    }()
    
    let emailLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Email: \(AppInfo.email.getValue())"
        label.font = label.font.withSize(18)
        label.numberOfLines = 0
        
        return label
        
    }()
    
    let phoneNumberLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Liên Hệ: \(AppInfo.phone.getValue())"
        label.font = label.font.withSize(18)
        label.numberOfLines = 0
        
        return label
        
    }()
    
    func addSubViews() {
        
        self.addSubview(titleLabel)
        self.addSubview(versionLabel)
        self.addSubview(emailLabel)
        self.addSubview(phoneNumberLabel)
   
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 10,
                                  y: 20,
                                  width: self.bounds.width,
                                  height: 0)
        titleLabel.sizeToFit()
        
        versionLabel.frame = CGRect(x: 10,
                                    y: titleLabel.frame.maxY + 10,
                                    width: self.bounds.width,
                                    height: 0)
        versionLabel.sizeToFit()
        
        emailLabel.frame = CGRect(x: 10,
                                  y: versionLabel.frame.maxY,
                                  width: self.bounds.width,
                                  height: 0)
        emailLabel.sizeToFit()
        
        phoneNumberLabel.frame = CGRect(x: 10,
                                        y: emailLabel.frame.maxY,
                                        width: self.bounds.width,
                                        height: 0)
        phoneNumberLabel.sizeToFit()
    }
}

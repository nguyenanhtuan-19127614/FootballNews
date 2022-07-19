//
//  AppInfoView.swift
//  FootballNews
//
//  Created by LAP13606 on 19/07/2022.
//

import UIKit

class AppInfoCell: UICollectionViewCell {
    
    //MARK: Overide Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .white
        
      
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define SubViews
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Thông tin App"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
        
    }()
    
    let versionLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Phiên Bản: \(AppInfo.version.getValue())"
        label.font = label.font.withSize(17)
        label.numberOfLines = 0
        
        return label
        
    }()
    
    let emailLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Email: \(AppInfo.email.getValue())"
        label.font = label.font.withSize(17)
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
                                  y: 10,
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

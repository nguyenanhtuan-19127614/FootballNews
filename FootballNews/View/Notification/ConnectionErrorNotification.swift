//
//  ConnectionErrorNotification.swift
//  FootballNews
//
//  Created by LAP13606 on 05/07/2022.
//

import Foundation
import UIKit

class ConnectionErrorNotification: UIViewController {
    
    let titleImage: UIImageView = {
       
        let imgView = UIImageView()
        imgView.image = UIImage(named: "connectionError")
        imgView.contentMode = .scaleAspectFit
        return imgView
        
    }()
    
    let messageLabel: UILabel = {
        
        let msg = "Không có kết nối mạng, danh sách tin sẽ được chuyển sang chế độ đọc offline."
        
        let label = UILabel()
        label.text = msg
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        return label
        
    }()
    
    let doneButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Đã hiểu", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        if #available(iOS 13.0, *) {
            
            let color = UIColor(cgColor: CGColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1))
            button.backgroundColor = color
             
        }
        
        button.layer.cornerRadius = 7.0
        button.layer.masksToBounds = true
        
        button.addTarget(nil, action: #selector(done), for: .touchUpInside)
      
        return button
        
    }()
    
    @objc func done() {
   
        self.dismiss(animated: true)
        
    }
    
    //MARK: Init
    
    override func loadView() {
        super.loadView()
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7.0
        self.view = view
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addSubViews()
        
    }
    
  
    func addSubViews() {
        
        self.view.addSubview(titleImage)
        self.view.addSubview(messageLabel)
        self.view.addSubview(doneButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            self.view.centerXAnchor.constraint(equalTo: self.view.superview!.centerXAnchor),
            self.view.centerYAnchor.constraint(equalTo: self.view.superview!.centerYAnchor),
            self.view.widthAnchor.constraint(equalToConstant: self.view.superview!.bounds.width - 100),
            self.view.heightAnchor.constraint(equalToConstant: self.view.superview!.bounds.height/4.5),
            
            messageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            messageLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 50),
            
            titleImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleImage.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -15),
            titleImage.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 30 ),
            titleImage.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 4),
            
            doneButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            doneButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
            doneButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 30),
            doneButton.heightAnchor.constraint(equalToConstant: 30)
                    
        ])
   
    }
}

//
//  LoadMoreIndicatorCell.swift
//  FootballNews
//
//  Created by LAP13606 on 24/06/2022.
//

import UIKit

class ErrorOccurredCell: UICollectionViewCell {
    
    weak var delegate: DataSoureDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
       
    }
    
    var errorImgView: UIImageView = {
        
        let imgView = UIImageView()
        imgView.image = UIImage(named: "error")
        return imgView
        
    }()
    
    var errorLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Đã Có Lỗi Xảy Ra"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
        
    }()
    
    var refreshButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Thử Lại", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        let color = UIColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1)
        button.backgroundColor = color
        
        button.layer.cornerRadius = 7.0
        button.layer.masksToBounds = true
    
        button.addTarget(nil, action: #selector(refresh), for: .touchUpInside)
        return button
        
    }()
    
    func addSubviews(){
        
        addSubview(errorImgView)
        addSubview(errorLabel)
        addSubview(refreshButton)
        
    }
    
    func addLayout() {
      
        errorImgView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
           
            errorImgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorImgView.bottomAnchor.constraint(equalTo: errorLabel.topAnchor, constant: -20),
            errorImgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            errorImgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
         
            refreshButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            refreshButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 30),
            refreshButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            refreshButton.heightAnchor.constraint(equalToConstant: 35)
                    
        ])
       
    }
    
    @objc func refresh() {
        
        self.delegate?.changeState(state: .loading)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.getData()
        }
        
    }
    
}

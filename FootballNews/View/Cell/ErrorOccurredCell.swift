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
        
        if #available(iOS 13.0, *) {
            let startColor = CGColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1)
            let middleColor = CGColor(red: 0.05, green: 0.39, blue: 0.59, alpha: 1)
            let endColor = CGColor(red: 0.04, green: 0.31, blue: 0.58, alpha: 1)
            
            let gradientImage = UIImage().createGradientImage(colors: [startColor,middleColor,endColor],
                                                              frame: button.frame)
            button.setBackgroundImage(gradientImage, for: .normal)
        }
        
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
    
    override func layoutSubviews() {
      
        errorImgView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
           
            errorImgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorImgView.bottomAnchor.constraint(equalTo: errorLabel.topAnchor, constant: -20),
            errorImgView.widthAnchor.constraint(equalToConstant: self.bounds.width / 3),
            errorImgView.heightAnchor.constraint(equalToConstant: self.bounds.width / 3),
            
            refreshButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            refreshButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 30),
            refreshButton.widthAnchor.constraint(equalToConstant: self.bounds.width / 3),
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

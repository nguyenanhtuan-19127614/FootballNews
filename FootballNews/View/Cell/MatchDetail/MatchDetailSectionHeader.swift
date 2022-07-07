//
//  MatchDetailSectionHeader.swift
//  FootballNews
//
//  Created by LAP13606 on 07/07/2022.
//

import UIKit


class MatchDetailSectionHeader: UICollectionReusableView {
    
    var selectedColor: UIColor?
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addShadow(color: UIColor.black.cgColor,
                       opacity: 1.0)

        if #available(iOS 13.0, *) {
            
            selectedColor = UIColor(cgColor: CGColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1))
            
        } else {
            
            selectedColor = .blue
            
        }
        
       //var selectionList = [newsContent,matchDetailContent,rankingContent]
        newsContent.textColor = selectedColor
        
        let tap = UITapGestureRecognizer(target: nil, action: #selector(selectLabel(_:)))
        newsContent.addGestureRecognizer(tap)
        //add sub views
        addSubViews()
        //add Gesture
        //addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Define Sub-views

    let newsContent: UILabel = {
        
        let label = UILabel()
        label.text = "Tin tức"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .lightGray
        
        label.numberOfLines = 0
        label.sizeToFit()
        
        label.isUserInteractionEnabled = true
        
        return label
        
    }()
    
    let matchDetailContent: UILabel = {
        
        let label = UILabel()
        label.text = "Chi tiết trận đấu"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .lightGray
        
        label.numberOfLines = 0
        label.sizeToFit()
        
        label.isUserInteractionEnabled = true
        
        return label
        
    }()
    
    let rankingContent: UILabel = {
        
        let label = UILabel()
        label.text = "Bảng xếp hạng"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .lightGray
        
        label.numberOfLines = 0
        label.sizeToFit()
        
        label.isUserInteractionEnabled = true
    
        return label
        
    }()
    
    //MARK: Tap Event
  
    @objc func selectLabel(_ sender: UITapGestureRecognizer?) {
        print("dasdadasda")
    }
    
    
    //MARK: Add subviews to cell
    func addSubViews() {
    
        addSubview(newsContent)
        addSubview(matchDetailContent)
        addSubview(rankingContent)
        
    }
    
    //MARK: Add gesture
//    func addGesture() {
//
//        newsContent.addGestureRecognizer(tap)
//        matchDetailContent.addGestureRecognizer(tap)
//        rankingContent.addGestureRecognizer(tap)
//
//    }
   
    //MARK: Add layout subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        newsContent.translatesAutoresizingMaskIntoConstraints = false
        matchDetailContent.translatesAutoresizingMaskIntoConstraints = false
        rankingContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            newsContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            newsContent.heightAnchor.constraint(equalToConstant: self.bounds.height),
            
            matchDetailContent.leadingAnchor.constraint(equalTo: newsContent.trailingAnchor, constant: 20),
            matchDetailContent.heightAnchor.constraint(equalToConstant: self.bounds.height),
            
            rankingContent.leadingAnchor.constraint(equalTo: matchDetailContent.trailingAnchor, constant: 20),
            rankingContent.heightAnchor.constraint(equalToConstant: self.bounds.height),
        
        ])

    }
    
}

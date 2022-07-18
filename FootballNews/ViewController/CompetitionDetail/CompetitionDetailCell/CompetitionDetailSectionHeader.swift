//
//  CompetitionDetailSectionHeader.swift
//  FootballNews
//
//  Created by LAP13606 on 12/07/2022.
//

import UIKit

class CompetitionDetailSectionHeader: UICollectionReusableView {
    
    var selectedColor: UIColor?
    weak var delegate: CompetitionDetailController?
    
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
        
        newsContent.textColor = selectedColor
    
        //add sub views
        addSubViews()
        //add Gesture
        addGestures()
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
    
    
    //MARK: Add subviews to cell
    func addSubViews() {
    
        addSubview(newsContent)
        addSubview(rankingContent)
        
    }
    
    //MARK: Add layout subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        newsContent.frame = CGRect(x: 20,
                                   y: 0,
                                   width: 0,
                                   height: self.bounds.height)
        newsContent.sizeToFit()
        newsContent.frame.size.height = self.bounds.height
        
        rankingContent.frame = CGRect(x: newsContent.frame.maxX + 20,
                                      y: 0,
                                      width: 0,
                                      height: self.bounds.height)
        rankingContent.sizeToFit()
        rankingContent.frame.size.height = self.bounds.height

    }
    
    //MARK: Add Gesture
    func addGestures() {
        
        let newsTap = UITapGestureRecognizer(target: self, action: #selector(selectNews(_:)))
        let rankingTap = UITapGestureRecognizer(target: self, action: #selector(selectRanking(_:)))
        
        newsContent.addGestureRecognizer(newsTap)
        rankingContent.addGestureRecognizer(rankingTap)
        
    }
    //MARK: Tap Event
  
    @objc func selectNews(_ sender: UITapGestureRecognizer?) {
        
        newsContent.textColor = selectedColor
        rankingContent.textColor = .lightGray
        
        delegate?.changeContentMatchDetail(content: .news)
        delegate?.reloadData()
    }
    
    @objc func selectRanking(_ sender: UITapGestureRecognizer?) {
        
        newsContent.textColor = .lightGray
        rankingContent.textColor = selectedColor
        
        delegate?.changeContentMatchDetail(content: .ranking)
        delegate?.reloadData()
        
    }
    
}

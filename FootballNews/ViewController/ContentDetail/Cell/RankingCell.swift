//
//  RankingCell.swift
//  FootballNews
//
//  Created by LAP13606 on 07/07/2022.
//

import UIKit

class RankingCell: UICollectionViewCell {
    
    var grayColor: UIColor = .lightGray.withAlphaComponent(0.2)
    
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        grayColor = UIColor(red: 232/255, green: 239/255, blue: 242/255, alpha: 1)
        
        //add colors for subviews border
        addBorderColor()
        //add sub views
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define Sub-views
    let indexLabel: PaddingLabel = {
        
        let label = PaddingLabel()
        label.textAlignment = .right
        label.setupPadding(top: 0, bottom: 0, left: 0, right: 10)
        label.layer.borderWidth = 1
        
        return label
        
    }()
    
    let teamNameLabel: PaddingLabel = {
        
        let label = PaddingLabel()
        label.textAlignment = .left
        label.setupPadding(top: 0, bottom: 0, left: 10, right: 0)
        label.layer.borderWidth = 1
       
        return label
        
    }()
    
    let playedLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
       
        return label
        
    }()
    
    let differenceLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        
        return label
    }()
    
    let pointsLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(indexLabel)
        addSubview(teamNameLabel)
        addSubview(playedLabel)
        addSubview(differenceLabel)
        addSubview(pointsLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
      
        indexLabel.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.bounds.width/10,
                                  height: self.bounds.height)
        
        pointsLabel.frame = CGRect(x: self.bounds.width - self.bounds.width/10,
                                   y: 0,
                                   width: self.bounds.width/10,
                                   height: self.bounds.height)
        
        differenceLabel.frame = CGRect(x: pointsLabel.frame.minX - self.bounds.width/10,
                                       y: 0,
                                       width: self.bounds.width/10,
                                       height: self.bounds.height)
    
        playedLabel.frame = CGRect(x: differenceLabel.frame.minX - self.bounds.width/10,
                                   y: 0,
                                   width: self.bounds.width/10,
                                   height: self.bounds.height)
        
        let teamNameLabelWidth = self.bounds.width - indexLabel.bounds.width + pointsLabel.bounds.width - differenceLabel.bounds.width - playedLabel.bounds.width
        teamNameLabel.frame = CGRect(x: indexLabel.frame.maxX,
                                     y: 0,
                                     width: teamNameLabelWidth,
                                     height: self.bounds.height)
        
    }
    
    func addBorderColor() {
        
        indexLabel.layer.borderColor = grayColor.cgColor
        teamNameLabel.layer.borderColor = grayColor.cgColor
        playedLabel.layer.borderColor = grayColor.cgColor
        differenceLabel.layer.borderColor = grayColor.cgColor
        pointsLabel.layer.borderColor = grayColor.cgColor
       
    }
    
    //MARK: Load data to cell
    func loadData(inputData: RankingModel, index: Int) {
    
        if index != 0 {
            
            indexLabel.text = String(index)
            teamNameLabel.text = inputData.teamName
            playedLabel.text = String(inputData.totalStat.played)
            differenceLabel.text = String(inputData.totalStat.difference)
            pointsLabel.text = String(inputData.totalStat.points)
            
        } else {
            
            indexLabel.text = "#"
            teamNameLabel.text = "Đội bóng"
            playedLabel.text = "ST"
            differenceLabel.text = "HS"
            pointsLabel.text = "Đ"
            
        }
        
        if index % 2 == 0 {
            
            self.backgroundColor = .white
            
        } else {
            
            self.backgroundColor = grayColor
            
        }
    }
}

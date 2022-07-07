//
//  RankingCell.swift
//  FootballNews
//
//  Created by LAP13606 on 07/07/2022.
//

import UIKit

class RankingCell: UICollectionViewCell {
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //add sub views
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define Sub-views
    let indexLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .right
        label.layer.borderWidth = 1
        
        return label
        
    }()
    
    let teamNameLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
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
      
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        teamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playedLabel.translatesAutoresizingMaskIntoConstraints = false
        differenceLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            indexLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            indexLabel.heightAnchor.constraint(equalToConstant: self.bounds.height),
            indexLabel.widthAnchor.constraint(equalToConstant: self.bounds.width/10),
            
            teamNameLabel.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor),
            teamNameLabel.trailingAnchor.constraint(equalTo: playedLabel.leadingAnchor),
            teamNameLabel.heightAnchor.constraint(equalToConstant: self.bounds.height),
            
            playedLabel.trailingAnchor.constraint(equalTo: differenceLabel.leadingAnchor),
            playedLabel.heightAnchor.constraint(equalToConstant: self.bounds.height),
            playedLabel.widthAnchor.constraint(equalToConstant: self.bounds.width/10),
         
            differenceLabel.trailingAnchor.constraint(equalTo: pointsLabel.leadingAnchor),
            differenceLabel.heightAnchor.constraint(equalToConstant: self.bounds.height),
            differenceLabel.widthAnchor.constraint(equalToConstant: self.bounds.width/10),
            
            pointsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pointsLabel.heightAnchor.constraint(equalToConstant: self.bounds.height),
            pointsLabel.widthAnchor.constraint(equalToConstant: self.bounds.width/10)
        
        ])
        
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
            
            self.backgroundColor = .lightGray
            
        }
    }
}

//
//  MatchDetailHeader.swift
//  FootballNews
//
//  Created by LAP13606 on 06/07/2022.
//

import UIKit

class MatchDetailHeader: UIView {
    
    weak var delegate: MatchDetailController?
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //gradient background
        if #available(iOS 13.0, *) {
            
            let startColor = CGColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1)
            let endColor = CGColor(red: 0.04, green: 0.31, blue: 0.58, alpha: 1)
            let colorsList = [startColor,endColor]
            
            if let gradientImage = UIImage().createGradientImage(colors: colorsList, frame: self.frame) {
                
                self.layer.contents = gradientImage.cgImage
                
            }
           

        }
        //add sub views
        addSubViews()
        
        //add Gestures
        addGestures()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Define Sub-views
    let homeTeam = TeamView()
    let awayTeam = TeamView()
    let scoreView = ScoreView()
    //MARK: Add subviews to cell
    func addSubViews() {
    
        addSubview(homeTeam)
        addSubview(awayTeam)
        addSubview(scoreView)
        
    }
    
   
    //MARK: Add layout subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        homeTeam.translatesAutoresizingMaskIntoConstraints = false
        awayTeam.translatesAutoresizingMaskIntoConstraints = false
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            homeTeam.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            homeTeam.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            homeTeam.widthAnchor.constraint(equalToConstant: self.bounds.width/4),
            homeTeam.heightAnchor.constraint(equalToConstant: self.bounds.height - 20),
            
            awayTeam.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            awayTeam.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            awayTeam.widthAnchor.constraint(equalToConstant: self.bounds.width/4),
            awayTeam.heightAnchor.constraint(equalToConstant: self.bounds.height - 20),
            
            scoreView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            scoreView.trailingAnchor.constraint(equalTo: awayTeam.leadingAnchor, constant: -30),
            scoreView.leadingAnchor.constraint(equalTo: homeTeam.trailingAnchor, constant: 30),
            scoreView.heightAnchor.constraint(equalToConstant: self.bounds.height - 20),
            
        ])
        
    }
    
    //MARK: Load data to cell
    func loadData(scoreBoard: HomeScoreBoardModel) {
        
        homeTeam.loadData(teamName: scoreBoard.homeName, teamLogo: scoreBoard.homeLogo)
        awayTeam.loadData(teamName: scoreBoard.awayName, teamLogo: scoreBoard.awayLogo)
        scoreView.loadData(scoreBoard: scoreBoard)
        
    }
    
    //MARK: Add Gesture
    
    func addGestures() {
        
        let homeTap = UITapGestureRecognizer(target: self, action: #selector(homeTap(_:)))
        let awayTap = UITapGestureRecognizer(target: self, action: #selector(awayTap(_:)))
        
        homeTeam.addGestureRecognizer(homeTap)
        awayTeam.addGestureRecognizer(awayTap)
        
    }
    
    //MARK: Tap Event
    
    @objc func homeTap(_ sender: UIGestureRecognizer?) {
        
        delegate?.homeTap()
        
    }
    
    @objc func awayTap(_ sender: UIGestureRecognizer?) {
        
        delegate?.awayTap()
        
    }
    
}

//Team Status View
class TeamView: UIView {

    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      
    }
    
    //MARK: Define SubViews
    
    let teamLogo: UIImageView = {
        
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        //imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = .white

        return imgView
        
    }()
    
    let teamName: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(teamLogo)
        addSubview(teamName)
       
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        teamLogo.translatesAutoresizingMaskIntoConstraints = false
        teamName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
       
            teamLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            teamLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            teamLogo.widthAnchor.constraint(equalToConstant: self.bounds.height/2.5),
            teamLogo.heightAnchor.constraint(equalToConstant: self.bounds.height/2.5),
            
            teamName.topAnchor.constraint(equalTo: teamLogo.bottomAnchor, constant: 10),
            teamName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            teamName.widthAnchor.constraint(equalToConstant: self.bounds.width),
      
        
        ])
        
        //Round border
        teamLogo.layer.cornerRadius = teamLogo.bounds.width/2
        
    }
    
    //MARK: Load data to cell
    func loadData(teamName: String, teamLogo: String) {
        //Subviews that don't need downloading
        self.teamName.text = teamName
    
        //Subviews that need downloading
        self.teamLogo.loadImageFromUrl(url: teamLogo)
    
    }

}

class ScoreView: UIView {
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      
    }
    
    //MARK: Define SubViews
    
    let homeScore: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor.white
        label.textAlignment = .left
        
        return label
        
    }()
    
    let awayScore: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor.white
        label.textAlignment = .right
       
        return label
    }()
    
    let matchDate: UILabel = {
        
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textColor = UIColor.white
        label.textAlignment = .center
       
        return label
        
    }()
    
    let matchTime: UILabel = {
        
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textColor = UIColor.white
        label.textAlignment = .center
       
        return label
        
    }()
    
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(homeScore)
        addSubview(awayScore)
        addSubview(matchTime)
        addSubview(matchDate)
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        homeScore.translatesAutoresizingMaskIntoConstraints = false
        awayScore.translatesAutoresizingMaskIntoConstraints = false
        matchTime.translatesAutoresizingMaskIntoConstraints = false
        matchDate.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            homeScore.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            homeScore.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            homeScore.widthAnchor.constraint(equalToConstant: self.bounds.width/2),
            homeScore.heightAnchor.constraint(equalToConstant: self.bounds.height/3),
            
            awayScore.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            awayScore.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            awayScore.widthAnchor.constraint(equalToConstant: self.bounds.width/2),
            awayScore.heightAnchor.constraint(equalToConstant: self.bounds.height/3),
            
            matchTime.topAnchor.constraint(equalTo: homeScore.bottomAnchor, constant: 0),
            matchTime.widthAnchor.constraint(equalToConstant: self.bounds.width),
           
            matchDate.topAnchor.constraint(equalTo: matchTime.bottomAnchor),
            matchDate.widthAnchor.constraint(equalToConstant: self.bounds.width),
            matchTime.heightAnchor.constraint(equalToConstant: 20),
            
            
        ])
        
    }
    
    //MARK: Load data to cell
    func loadData(scoreBoard: HomeScoreBoardModel) {
        
        let matchStatus = scoreBoard.status
        
        let date = Date().timestampToDate(scoreBoard.startTime)
      
        if matchStatus == 1 {
            
            homeScore.text = "-"
            awayScore.text = "-"
            matchDate.text = Date().dateToString(date)
            matchTime.text = scoreBoard.time
            
            
        } else if matchStatus == 2 {
            
            homeScore.text = String(scoreBoard.homeScore)
            awayScore.text = String(scoreBoard.awayScore)
            matchDate.text = Date().dateToString(date)
            matchTime.text = scoreBoard.time
            
        } else {
            
            homeScore.text = String(scoreBoard.homeScore)
            awayScore.text = String(scoreBoard.awayScore)
            matchDate.text = Date().dateToString(date)
            matchTime.text = scoreBoard.time
            
        }

       
    }
}

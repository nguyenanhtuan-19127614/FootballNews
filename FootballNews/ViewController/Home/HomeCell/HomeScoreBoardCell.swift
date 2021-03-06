import UIKit

//MARK: Home - ScoreBoard Cell
class HomeScoreBoardCell: UICollectionViewCell {
    
    var isPadding = false
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .white
        //custom parent view
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 8.0
    
        //add sub views
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Define Sub-views
    
    let statusView: UILabel = {
        
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4.0
        return label
        
    }()
    
    let competitionLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1)
        return label
        
    }()
    
    let timeLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor(red: 0.694, green: 0.694, blue: 0.694, alpha: 1)
        return label
        
    }()
    
    let homeTeam = ScoreBoardTeamStatus()
    
    let awayTeam = ScoreBoardTeamStatus() 
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(statusView)
        addSubview(competitionLabel)
        addSubview(timeLabel)
        addSubview(homeTeam)
        addSubview(awayTeam)
        
    }
    
    //MARK: Prepared For Reuse
    override func prepareForReuse() {
        
        homeTeam.logoTeam.image = nil
        awayTeam.logoTeam.image = nil
        
    }
    
    //MARK: Add layout for subviews
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        statusView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.bounds.width/50,
                                  height: self.bounds.height)
        
        competitionLabel.frame = CGRect(x: statusView.frame.maxX + 12,
                                        y: 8,
                                        width: 0,
                                        height: 0)
        competitionLabel.sizeToFit()
        
        timeLabel.frame = CGRect(x: statusView.frame.maxX + 12,
                                 y: competitionLabel.frame.maxY + 6,
                                 width: 0,
                                 height: 0)
        timeLabel.sizeToFit()
        
        homeTeam.frame = CGRect(x: statusView.frame.maxX + 12,
                                y: timeLabel.frame.maxY + 7,
                                width: self.bounds.width - 20,
                                height: competitionLabel.bounds.height)

        awayTeam.frame = CGRect(x: statusView.frame.maxX + 12,
                                y: homeTeam.frame.maxY + 10,
                                width: homeTeam.bounds.width,
                                height: competitionLabel.bounds.height)
        
      
    }
    
    //MARK: Load data to cell
    
    func loadData(inputData: HomeScoreBoardModel) {
        
        //Subviews that don't need downloading
        self.competitionLabel.text = inputData.competition
        let date = Date().timestampToDate(inputData.startTime)
       
        //Subviews that need downloading
        self.homeTeam.loadData(logoTeam: inputData.homeLogo,
                          teamName: inputData.homeName,
                          scoreLabel: String(inputData.homeScore))
        
        self.awayTeam.loadData(logoTeam: inputData.awayLogo,
                          teamName: inputData.awayName,
                          scoreLabel: String(inputData.awayScore))
        
        //Load status bar, timelabel based on status bar
      
        switch inputData.status {
            
        // Live Match
        case 0:
            self.statusView.backgroundColor = .red
            self.timeLabel.text = "Tr???c ti???p -" + Date().dateToString(date)
            self.timeLabel.textColor = .red
        
        // Future Match
        case 1:
            self.statusView.backgroundColor = UIColor(red: 0, green: 0.533, blue: 0.525, alpha: 1)
            self.timeLabel.text = Date().dateToString(date, fullDate: true)
            self.homeTeam.scoreLabel.text = "-"
            self.awayTeam.scoreLabel.text = "-"
        
        // Complete Match
        case 2:
            self.statusView.backgroundColor = .gray
            self.timeLabel.text = "???? K???t Th??c - " + Date().dateToString(date)
            
            if inputData.awayScore < inputData.homeScore {
                
                awayTeam.scoreLabel.textColor = UIColor.lightGray
                
            } else if inputData.homeScore < inputData.awayScore {
                
                homeTeam.scoreLabel.textColor = UIColor.lightGray
                
            }
            
        default:
            self.statusView.backgroundColor = .white
            
        }
        
        
    }
}


class ScoreBoardTeamStatus: UIView {
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      
    }
    
    //MARK: Define SubViews
    
    let logoTeam: UIImageView = {
        
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFit
        
        return imgView
        
    }()
    
    let teamName: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
        
    }()
    
    let scoreLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addSubViews() {
        
        addSubview(logoTeam)
        addSubview(teamName)
        addSubview(scoreLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        logoTeam.frame = CGRect (x: 0,
                                 y: 0,
                                 width: self.bounds.width / 9,
                                 height: self.bounds.height)
        
        teamName.frame = CGRect (x: logoTeam.frame.maxX + 8,
                                 y: 0,
                                 width: self.bounds.width / 1.5,
                                 height: self.bounds.height)
        
        scoreLabel.frame = CGRect (x: self.bounds.width - 20,
                                   y: 0,
                                   width: 6,
                                   height: self.bounds.height)
        scoreLabel.sizeToFit()
        
        
    }
    
    //MARK: Load data to cell
    
    func loadData(logoTeam: String, teamName: String, scoreLabel: String) {
        
        //Subviews that don't need downloading
        self.teamName.text = teamName
        self.scoreLabel.text = scoreLabel
    
        //Subviews that need downloading
        self.logoTeam.loadImageFromUrl(url: logoTeam)
    }
    
}

import UIKit

//MARK: Home - ScoreBoard Cell
class HomeScoreBoardCell: UICollectionViewCell {
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Define Sub-views
    
    let competitionLabel: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    let timeLabel: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    
    
    //MARK: Add subviews to cell
    func addViews() {
        
    }
    
    //MARK: Add layout for subviews
    
    override func layoutSubviews() {
        
        
    }
    
    //MARK: Load data to cell
    
    func loadData() {
        
        
    }
}


fileprivate class ScoreBoardTeamStatus: UIView {
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define SubViews
    
    let logoTeam: UIImageView = {
        
        let imgView = UIImageView()
        return imgView
        
    }()
    
    let teamName: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    let scoreLabel: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addViews() {
        
        addSubview(logoTeam)
        addSubview(teamName)
        addSubview(scoreLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        logoTeam.frame = CGRect (x: 0,
                                 y: 0,
                                 width: 0,
                                 height: 0)
        
    }
    
    //MARK: Load data to cell
    
    func loadData() {
        
    }
    
}


import UIKit

class ArticelDetailHeaderCell: UICollectionViewCell {
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define Subviews
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
        
    }()
    
    let subTitleLabel: Subtitle = {
        
        let label = Subtitle()
    
        return label
        
    }()
    
    let descriptionLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addViews() {
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(descriptionLabel)
    
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        titleLabel.frame = CGRect(x: 15,
                                  y: 20,
                                  width: self.bounds.width - 20,
                                  height: 0)
        titleLabel.sizeToFit()
       
 
        
        subTitleLabel.frame = CGRect(x: 15,
                                     y: titleLabel.frame.maxY + 20,
                                     width: self.bounds.width - 20,
                                     height: 30)
        
        descriptionLabel.frame = CGRect(x: 15,
                                        y: subTitleLabel.frame.maxY + 20,
                                        width: self.bounds.width - 20,
                                        height: 0)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.sizeToFit()
        
    }
    
    //MARK: Load Data
    func loadData(_ inputData: ArticelDetailData) {
        
        titleLabel.text = inputData.title
        descriptionLabel.text = inputData.description
        
        subTitleLabel.loadData(sourceIcon: inputData.sourceIcon,
                               sourceLabel: inputData.source,
                               date: String(inputData.date))
        
    }
}

//View Class

class Subtitle: UIView {
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Define Subviews
    let sourceIcon: UIImageView = {
        
        let imgView = UIImageView()
        return imgView
        
    }()
    
    let sourceLabel: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    let date: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addViews() {
        
        addSubview(sourceIcon)
        addSubview(sourceLabel)
        addSubview(date)
    
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        sourceIcon.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.bounds.height,
                                  height: self.bounds.height)
        
        sourceLabel.frame = CGRect(x: sourceIcon.frame.maxX + 10,
                                   y: 0,
                                   width: 100,
                                   height: self.bounds.height)
        sourceLabel.font = UIFont.systemFont(ofSize: 15)
        
        date.frame = CGRect(x: sourceLabel.frame.maxX + 5,
                            y: 0,
                            width: 100,
                            height: self.bounds.height)
        date.font = UIFont.systemFont(ofSize: 15)
        
    }
    
    //MARK: Load data to cell
    func loadData(sourceIcon: String,sourceLabel: String,date: String) {
        
        self.sourceIcon.loadImage(url: sourceIcon)
        self.sourceLabel.text = sourceLabel
        
        let date = DateManager.shared.timestampToDate(date)
        self.date.text = DateManager.shared.dateToString(date)
        
    }
}


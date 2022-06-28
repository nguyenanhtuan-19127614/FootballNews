
import UIKit

fileprivate let paddingLeft = 15.0

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
        label.font = UIFont.boldSystemFont(ofSize: 30)
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
        label.font = UIFont.boldSystemFont(ofSize: 25)
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
        
        titleLabel.frame = CGRect(x: paddingLeft,
                                  y: 20,
                                  width: self.bounds.width - 35,
                                  height: 0)
        titleLabel.sizeToFit()
       
 
        
        subTitleLabel.frame = CGRect(x: paddingLeft,
                                     y: titleLabel.frame.maxY + 10.0,
                                     width: self.bounds.width - 35,
                                     height: 30)
        
        descriptionLabel.frame = CGRect(x: paddingLeft,
                                        y: subTitleLabel.frame.maxY + 10.0,
                                        width: self.bounds.width - 35,
                                        height: 0)
        descriptionLabel.sizeToFit()
        
        self.sizeToFit()
        
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

//subtitle Class 

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
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        
        return label
        
    }()
    
    let date: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
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
                                   width: sourceLabel.calculateWidth(cellHeight: self.bounds.height),
                                   height: self.bounds.height)
        
        //sourceLabel.layer.borderWidth = 1
        
        date.frame = CGRect(x: sourceLabel.frame.maxX + 5,
                            y: 0,
                            width: date.calculateWidth(cellHeight: self.bounds.height),
                            height: self.bounds.height)
      
        
    }
    
    //MARK: Load data to cell
    func loadData(sourceIcon: String,sourceLabel: String,date: String) {
        
        self.sourceIcon.loadImageFromUrl(url: sourceIcon)
        self.sourceLabel.text = sourceLabel
        
        let date = Date().timestampToDate(date)
        self.date.text = Date().dateToString(date)
        
    }
}


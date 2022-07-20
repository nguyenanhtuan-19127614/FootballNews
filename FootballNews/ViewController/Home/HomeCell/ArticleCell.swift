

import UIKit


class ArticleCell: UICollectionViewCell {
    
    var avatarURL: String?
    var publisherLogoURL: String?
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        
    }

    // MARK: Define Sub-view
    let newsAvatar: UIImageView = {
        
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 5.0
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFill

        return imgView
        
    }()
    
    let title: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
  
        return label
        
    }()
    
    let publisherLogo: UIImageView = {
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.layer.masksToBounds = true
        
        return imgView
        
    }()
    
    let timeLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        
        return label
        
    }()
    
    //MARK: Add subviews to cell
    func addViews() {
        
        addSubview(newsAvatar)
        addSubview(title)
        addSubview(publisherLogo)
        addSubview(timeLabel)
        
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        newsAvatar.image = nil
        newsAvatar.stopLoadImagefromURL(url: avatarURL)
        
        publisherLogo.image = nil
        publisherLogo.stopLoadImagefromURL(url: publisherLogoURL)
        
        title.text = nil
        timeLabel.text = nil
        
        avatarURL = ""
        publisherLogoURL = ""
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        newsAvatar.frame = CGRect(x: 18,
                                  y: 18,
                                  width: bounds.height + 20,
                                  height: bounds.height - 18)
        
        title.frame = CGRect(x: newsAvatar.frame.maxX + 15,
                             y: 18,
                             width: self.bounds.width - newsAvatar.bounds.width - 50,
                             height: 0)
        title.font = UIFont.boldSystemFont(ofSize: self.bounds.width/25)
        title.sizeToFit()

        
        publisherLogo.frame = CGRect(x: newsAvatar.frame.maxX + 15,
                                     y: newsAvatar.frame.maxY - bounds.height/7 ,
                                    width: title.bounds.width / 5,
                                    height: bounds.height/7)
        
        timeLabel.frame = CGRect(x: publisherLogo.frame.maxX + 10,
                                 y: publisherLogo.frame.minY,
                                 width: self.bounds.width - publisherLogo.bounds.width,
                                 height: publisherLogo.bounds.height)
        timeLabel.font = title.font.withSize(10)
        timeLabel.sizeToFit()
        timeLabel.frame.size.height = publisherLogo.bounds.height
        
    }
    
    //MARK: Load data to cell
    func loadData(inputData: HomeArticleModel) {
        
        //Subviews that don't need downloading
        self.title.text = inputData.title
        
        let date = Date().timestampToDate(String(inputData.date))
    
        if let date = date {
        
            self.timeLabel.compareDatewithToday(date: date)
            
        }
        
        //Subviews that need downloading
       
        self.newsAvatar.loadImageFromUrl(url: inputData.avatar)
        self.publisherLogo.loadImageFromUrl(url: inputData.publisherLogo)
       
        self.avatarURL = inputData.avatar
        self.publisherLogoURL = inputData.publisherLogo
        
    }

}



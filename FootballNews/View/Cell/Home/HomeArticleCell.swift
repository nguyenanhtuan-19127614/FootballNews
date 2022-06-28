

import UIKit


class HomeArticleCell: UICollectionViewCell {
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: prepareForReuse
    override func prepareForReuse() {
        
        super.prepareForReuse()
        newsAvatar.image = nil
        publisherLogo.image = nil
        title.text = nil
        
    }
    // MARK: Define Sub-view
    let newsAvatar: UIImageView = {
        
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 10.0
        imgView.layer.masksToBounds = true
       
        
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
    
    let ellipsisLabel: UILabel = {
        
        let label = UILabel()
        label.text = "..."
        return label
        
    }()
    
   
    //MARK: Add subviews to cell
    func addViews() {
        
        addSubview(newsAvatar)
        addSubview(title)
        addSubview(publisherLogo)
        addSubview(timeLabel)
        addSubview(ellipsisLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        newsAvatar.frame = CGRect(x: 18,
                                  y: 20,
                                  width: bounds.height + 10,
                                  height: bounds.height - 20)
        
        title.frame = CGRect(x: newsAvatar.frame.maxX + 15,
                             y: 20,
                             width: self.bounds.width - newsAvatar.bounds.width - 50,
                             height: 0)
        title.font = UIFont.boldSystemFont(ofSize: self.bounds.width / 25)
        title.sizeToFit()
        
        publisherLogo.frame = CGRect(x: newsAvatar.frame.maxX + 15,
                                    y: bounds.height - bounds.height/7 ,
                                    width: title.bounds.width / 5,
                                    height: bounds.height/7)
        
        timeLabel.frame = CGRect(x: publisherLogo.frame.maxX + 10,
                                 y: publisherLogo.frame.minY,
                                 width: self.bounds.width - publisherLogo.bounds.width,
                                 height: publisherLogo.bounds.height)
        timeLabel.font = title.font.withSize(10)
        timeLabel.sizeToFit()
        timeLabel.frame.size.height = publisherLogo.bounds.height
        
        ellipsisLabel.frame = CGRect(x: self.frame.maxX - self.bounds.width/10,
                                     y: publisherLogo.frame.minY ,
                                     width: title.bounds.width / 10,
                                     height: publisherLogo.bounds.height)
        
        
    }
    
    //MARK: Load data to cell
    func loadData(inputData: HomeArticleData) {
        
        //Subviews that don't need downloading
        self.title.text = inputData.title
        
        let date = Date().timestampToDate(String(inputData.date))
    
        if let date = date {
        
            self.timeLabel.compareDatewithToday(date: date)
            
        }
        
        //Subviews that need downloading
       
        self.newsAvatar.loadImageFromUrl(url: inputData.avatar)
        
        self.publisherLogo.loadImageFromUrl(url: inputData.author)
       
    }

}



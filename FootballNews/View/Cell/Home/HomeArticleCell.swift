

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
    
    let authorAvatar: UIImageView = {
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        return imgView
        
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
        addSubview(authorAvatar)
        addSubview(ellipsisLabel)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        newsAvatar.frame = CGRect(x: 18,
                                  y: 18,
                                  width: bounds.height + 10,
                                  height: bounds.height - 20)
        
        title.frame = CGRect(x: newsAvatar.frame.maxX + 15,
                             y: 18,
                             width: self.bounds.width - newsAvatar.bounds.width - 50,
                             height: 0)
        title.font = UIFont.boldSystemFont(ofSize: self.bounds.width / 25)
        title.sizeToFit()
        
        authorAvatar.frame = CGRect(x: newsAvatar.frame.maxX + 15,
                                    y: bounds.height - bounds.height/7 ,
                                    width: title.bounds.width / 3,
                                    height: bounds.height/7)
        
        ellipsisLabel.frame = CGRect(x: self.frame.maxX - self.bounds.width/10,
                                     y: authorAvatar.frame.minY ,
                                     width: title.bounds.width / 10,
                                     height: authorAvatar.bounds.height)
        
        
    }
    
    //MARK: Load data to cell
    func loadData(inputData: HomeArticleData) {
        
        //Subviews that don't need downloading
        self.title.text = inputData.title
    
        //Subviews that need downloading
       
        self.newsAvatar.loadImage(url: inputData.avatar)
        
        self.authorAvatar.loadImage(url: inputData.author)
       
    }

}



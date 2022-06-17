

import UIKit

class HomeListingCell: UICollectionViewCell {
    
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
        //imgView.image = UIImage(named: "loading")
        
        return imgView
        
    }()
    
    let title: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
        
    }()
    
    let authorAvatar: UIImageView = {
        
        let imgView = UIImageView()

        return imgView
        
    }()
    
    //MARK: Add subviews to cell
    func addViews() {
        
        addSubview(newsAvatar)
        addSubview(title)
        addSubview(authorAvatar)
        
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
        title.sizeToFit()
        
        authorAvatar.frame = CGRect(x: newsAvatar.frame.maxX + 15,
                                    y: bounds.height - bounds.height/8 ,
                                    width: title.bounds.width / 3,
                                    height: bounds.height/7)
        
    }
    
    //MARK: Load data to cell
    func loadData(inputData: HomeListingData) {
        
        //Subviews that don't need downloading
        self.title.text = inputData.title
    
        //Subviews that need downloading
        self.newsAvatar.loadImage(url: inputData.avatar)
        self.authorAvatar.loadImage(url: inputData.author)
        
    }

}

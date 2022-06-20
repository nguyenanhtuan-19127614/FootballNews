

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
        //imgView.image = UIImage(named: "loading")
        
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

//MARK: TESTING===========================================================================
class HomeCompetitionCollectionCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var competitionData: [HomeCompetitionData] = []
    var competitionCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: Overide Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Define Sub-view
   
    
    //MARK: Add subviews to cell
    func addViews() {
    
        competitionCollection.register(HomeCompetitionCell.self, forCellWithReuseIdentifier: "HomeCompetitionCell")
        
        competitionCollection.dataSource = self
        competitionCollection.delegate = self
        
        addSubview(competitionCollection)
        
    }
    
    //MARK: Add layout for subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        let competitionLayout = UICollectionViewFlowLayout()
        competitionLayout.itemSize = CGSize(width: self.bounds.width/4,
                                            height: self.bounds.height)
        competitionLayout.minimumLineSpacing = 20
        competitionLayout.scrollDirection = .horizontal
        
        self.competitionCollection = UICollectionView(frame: .zero, collectionViewLayout: competitionLayout)
        
        self.competitionCollection.frame = CGRect(x: self.frame.minX,
                                             y: 0,
                                             width: self.bounds.width,
                                             height: self.bounds.height)
        
        addViews()
    }
    
    //MARK: Load data to cell
    func loadData(inputData: [HomeCompetitionData]) {
        
        self.competitionData = inputData
        DispatchQueue.main.async {
            
            self.competitionCollection.reloadData()
            
        }
        
    }
    
    //MARK: Datasource Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return competitionData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let competitionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCompetitionCell", for: indexPath) as! HomeCompetitionCell
        
        competitionCell.backgroundColor = UIColor.white
        competitionCell.loadData(inputData: competitionData[indexPath.row])
        
        return competitionCell
        
    }

}

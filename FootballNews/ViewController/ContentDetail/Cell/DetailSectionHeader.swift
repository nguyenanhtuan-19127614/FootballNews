
import UIKit

class DetailSectionHeader: UICollectionReusableView {
    
    var selectedColor: UIColor?
    weak var delegate: DataSoureDelegate?
    
    //MARK: Override Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .white
       
        selectedColor = UIColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1)
        
        //Select news content first
        newsContent.textColor = selectedColor
      
        //add sub views
        addSubViews()
        //add Gesture
        addGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Define Sub-views

    let newsContent: UILabel = {
        
        let label = UILabel()
        label.text = "Tin tức"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .lightGray
        
        label.numberOfLines = 0
        label.sizeToFit()
        
        label.isUserInteractionEnabled = true
        
        return label
        
    }()
    
    let rankingContent: UILabel = {
        
        let label = UILabel()
        label.text = "Bảng xếp hạng"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .lightGray
        
        label.numberOfLines = 0
        label.sizeToFit()
        
        label.isUserInteractionEnabled = true
    
        return label
        
    }()
    
    
    //MARK: Add subviews to cell
    func addSubViews() {
    
        addSubview(newsContent)
        addSubview(rankingContent)
        
    }
    
    //MARK: Add layout subviews
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        newsContent.frame = CGRect(x: 20,
                                   y: 0,
                                   width: 0,
                                   height: self.bounds.height)
        newsContent.sizeToFit()
        newsContent.frame.size.height = self.bounds.height
        
        rankingContent.frame = CGRect(x: newsContent.frame.maxX + 20,
                                      y: 0,
                                      width: 0,
                                      height: self.bounds.height)
        rankingContent.sizeToFit()
        rankingContent.frame.size.height = self.bounds.height

        //add shadow
        self.addShadow(color: UIColor.black.cgColor,
                       opacity: 0.1,
                       offset: CGSize(width: 0.0, height: 1.0))

        //Underline news content
        newsContent.drawUnderlineAnimation(lineColor: selectedColor, lineWidth: 3, duration: 0)
        
    }
    
    //MARK: Add Gesture
    func addGestures() {
        
        let newsTap = UITapGestureRecognizer(target: self, action: #selector(selectNews(_:)))
        let rankingTap = UITapGestureRecognizer(target: self, action: #selector(selectRanking(_:)))
        
        newsContent.addGestureRecognizer(newsTap)
        rankingContent.addGestureRecognizer(rankingTap)
        
    }
    
    //MARK: Tap Event
    @objc func selectNews(_ sender: UITapGestureRecognizer?) {
      
        //Remove Underline Animation
        rankingContent.removeUnderline()
       
        //Underline Animation
        newsContent.drawUnderlineAnimation(lineColor: selectedColor, lineWidth: 3, duration: 0.2)
       
        newsContent.textColor = selectedColor
        rankingContent.textColor = .lightGray
        
        delegate?.changeContent(content: .news)
        delegate?.reloadData()
    }
    
    @objc func selectRanking(_ sender: UITapGestureRecognizer?) {
        
        //Remove Underline Animation
        newsContent.removeUnderline()
        
        //Underline Animation
        rankingContent.drawUnderlineAnimation(lineColor: selectedColor, lineWidth: 3, duration: 0.2)
    
        newsContent.textColor = .lightGray
        rankingContent.textColor = selectedColor
        
        delegate?.changeContent(content: .ranking)
        delegate?.reloadData()
        
    }
    
}

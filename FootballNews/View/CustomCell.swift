//
//  CustomCell.swift
//  FootballNews
//
//  Created by LAP13606 on 15/06/2022.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let newsAvatar: UIImageView = {
        
        let imgView = UIImageView()
        //imgView.backgroundColor = .red
        imgView.layer.cornerRadius = 10.0
        imgView.layer.masksToBounds = true
        
        return imgView
        
    }()
    
    let title: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        return label
        
    }()
    
    let authorAvatar: UIImageView = {
        
        let imgView = UIImageView()

        return imgView
        
    }()
    
    func addViews() {
        
        self.backgroundColor = .white
        addSubview(newsAvatar)
        addSubview(title)
        addSubview(authorAvatar)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        newsAvatar.frame = CGRect(x: 0,
                                  y: 0,
                                  width: bounds.height + 25,
                                  height: bounds.height)
        
        title.frame = CGRect(x: newsAvatar.bounds.width + 15,
                             y: 0,
                             width: bounds.width - newsAvatar.bounds.width,
                             height: 0)
        title.sizeToFit()
        
        authorAvatar.frame = CGRect(x: newsAvatar.bounds.width + 15,
                                    y: bounds.height - bounds.height/8 ,
                                    width: title.bounds.width / 3,
                                    height: bounds.height/8)
        
    }
    
    func loadData(inputData: CustomNewsData) {
        
        let gr = DispatchGroup()
        gr.enter()
        ImageDownloader.sharedService.download(url: inputData.avatar) { [weak self] result in
            
            switch result {
                
            case .success(let data):
                DispatchQueue.main.async {
                    self?.newsAvatar.image = UIImage(data: data)
                }
            
            case .failure(let err):
                print(err)
            }
            gr.leave()
        }
        
        gr.enter()
        ImageDownloader.sharedService.download(url: inputData.author) { [weak self] result in
            
            switch result {
                
            case .success(let data):
                DispatchQueue.main.async {
                    self?.authorAvatar.image = UIImage(data: data)
                }
            
            case .failure(let err):
                print(err)
            }
            gr.leave()
        }
        gr.wait()
        //self.newsAvatar.image = UIImage(data: avatar)
        //self.authorAvatar.image = UIImage(data: author)
        self.title.text = inputData.title
        
    }
    
}

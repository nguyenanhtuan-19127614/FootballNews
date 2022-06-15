//
//  ViewController.swift
//  FootballNews
//
//  Created by LAP13606 on 06/06/2022.
//

import UIKit

struct CustomNewsData {
    
    var avatar: String
    var title: String
    var author: String
    var link: String
}

class ViewController : UIViewController {
    
    var data: [CustomNewsData] = []
    var myCollectionView:UICollectionView?
    
    override func loadView() {
        
        //build view
        super.loadView()
        let view = UIView()
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.bounds.width - 60, height: self.view.bounds.height/9)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 30,left: 0,bottom: 10,right: 0)
        
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)

        myCollectionView?.register(NewsCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        
        
        //refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        myCollectionView?.addSubview(refreshControl)

        view.addSubview(myCollectionView ?? UICollectionView())
        
        self.view = view
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //get data
        QueryService.sharedService.get(ContentAPITarget.home) {
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.contents {
                    
                    for i in contents {
                        
                        DispatchQueue.main.async {
                            
                            self?.data.append(CustomNewsData(avatar: i.avatar, title: i.title, author: i.publisherLogo, link: i.url))
                            self?.myCollectionView?.reloadData()
                            
                        }
                    }
                }
                
            case .failure(let err):
                print(err)
                
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        QueryService.sharedService.get(ContentAPITarget.home) {
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.contents {
                    
                    for i in contents {
                        
                        DispatchQueue.main.async {
                            
                            self?.data.append(CustomNewsData(avatar: i.avatar, title: i.title, author: i.publisherLogo, link: i.url))
                            self?.myCollectionView?.reloadData()
                            
                        }
                    }
                }
                
            case .failure(let err):
                print(err)
                
            }
            
        }
        
    }
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(data.count)
        return data.count // How many cells to display
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! NewsCell
        
        myCell.backgroundColor = UIColor.white
       
        myCell.loadData(inputData: data[indexPath.row])
        return myCell
    }
    
}

extension ViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("User tapped on item \(indexPath.row)")
        guard let url = URL(string: data[indexPath.row].link) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    
    
}

//
//  ViewController.swift
//  FootballNews
//
//  Created by LAP13606 on 06/06/2022.
//

import UIKit

//refresh
//        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Refresh List News")
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//
//        myCollectionView?.addSubview(refreshControl)

//Data for Listing
struct HomeListingData {
    
    var avatar: String
    var title: String
    var author: String
    var link: String
    
}

struct HomeScoreBoardData {
    
    var status: Int
    var competition: String
    var time: String
    
    var homeLogo: String
    var homeName: String
    var homeScore: Int
    
    var awayLogo: String
    var awayName: String
    var awayScore: Int
    
}

class ViewController : UIViewController {
    
    var listingData: [HomeListingData] = []
    var scoreBoardData: [HomeScoreBoardData] = []
    
    var listingCollection: UICollectionView?
    var scoreBoardCollection: UICollectionView?
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        //MARK: Create customView
        let view = UIView()
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.937, green: 0.933, blue: 0.957, alpha: 1).cgColor
        
        //MARK: Score Board Collection View
        let scoreBoardLayout = UICollectionViewFlowLayout()

        scoreBoardLayout.itemSize = CGSize(width: self.view.bounds.width/1.5,
                                           height: self.view.bounds.height/7)
        
        scoreBoardLayout.minimumLineSpacing = 20
        scoreBoardLayout.scrollDirection = .horizontal
        
        scoreBoardCollection = UICollectionView(frame: .zero, collectionViewLayout: scoreBoardLayout)
        scoreBoardCollection?.backgroundColor = UIColor.white
        
        scoreBoardCollection?.register(HomeScoreBoardCell.self, forCellWithReuseIdentifier: "HomeScoreBoardCell")
        scoreBoardCollection?.dataSource = self
        scoreBoardCollection?.delegate = self
        
        //MARK: News Listing Collection View
        let listingLayout = UICollectionViewFlowLayout()
        listingLayout.itemSize = CGSize(width: self.view.bounds.width,
                                        height: self.view.bounds.height/7)
        listingLayout.minimumLineSpacing = 25

        listingCollection = UICollectionView(frame: .zero, collectionViewLayout: listingLayout)
        listingCollection?.backgroundColor = UIColor.white
        
        listingCollection?.register(HomeListingCell.self, forCellWithReuseIdentifier: "HomeListingCell")
        listingCollection?.dataSource = self
        listingCollection?.delegate = self
        
        
        //MARK: Add layout and Subviews
        addSubviewsLayout()
        view.addSubview(listingCollection ?? UICollectionView())
        view.addSubview(scoreBoardCollection ?? UICollectionView())
       
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //get data score board
        QueryService.sharedService.get(MatchAPITarget.matchByDate(compID: "0", date: "20220308")) {
            [weak self]
            (result: Result<ResponseModel<MatchModel>, Error>) in
            switch result {
                
            case .success(let res):
                if let soccerMatch = res.data?.soccerMatch {
                    for i in soccerMatch {
                        
                        DispatchQueue.main.async {
                            
                            self?.scoreBoardData.append(HomeScoreBoardData(
                                status: i.matchStatus,
                                competition: i.competition.competitionName,
                                time: i.startTime,
                                homeLogo: i.homeTeam.teamLogo,
                                homeName: i.homeTeam.teamName,
                                homeScore: i.homeScored,
                                awayLogo: i.awayTeam.teamLogo,
                                awayName: i.awayTeam.teamName,
                                awayScore: i.awayScored))
                            
                            self?.scoreBoardCollection?.reloadData()
                            
                        }
                    }
                }
                
//
       
            case .failure(let err):
                print(err)
                
            }
            
        }
        
        
        //get data home news
        QueryService.sharedService.get(ContentAPITarget.home) {
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.contents {
                    
                    for i in contents {
                        
                        DispatchQueue.main.async {
                            
                            self?.listingData.append(HomeListingData(avatar: i.avatar, title: i.title, author: i.publisherLogo, link: i.url))
                            
                            //Reload all collection data
                            self?.listingCollection?.reloadData()

                        }
                    }
                }
                
            case .failure(let err):
                print(err)
                
            }
        }
    }
    
    //MARK: Function to add layout for subviews
    func addSubviewsLayout() {
        
        //Scoreboard Collection
        scoreBoardCollection?.frame = CGRect(x: 0,
                                             y: 10,
                                             width: self.view.bounds.width ,
                                             height: self.view.bounds.height/3 - 100)
        
        //Listing Collection
    
        listingCollection?.frame = CGRect(x: 0,
                                          y: (scoreBoardCollection?.frame.maxY)! + 10 ,
                                          width: self.view.bounds.width,
                                          height: self.view.bounds.height / 3 + 200)
        
    }

}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == listingCollection {
            
            print(listingData.count)
            return listingData.count
            
        }
        
        else if collectionView == scoreBoardCollection {
            
            print(scoreBoardData.count)
            return scoreBoardData.count
            
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == listingCollection {
            
            let listingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListingCell", for: indexPath) as! HomeListingCell
            
            listingCell.backgroundColor = UIColor.white
            listingCell.loadData(inputData: listingData[indexPath.row])
            
            return listingCell
            
        }
        else {
            
            let scoreBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScoreBoardCell", for: indexPath) as! HomeScoreBoardCell
            
            scoreBoardCell.backgroundColor = UIColor.white
            scoreBoardCell.loadData(inputData: scoreBoardData[indexPath.row])
            
            return scoreBoardCell
            
        }
    }
    
}

extension ViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == listingCollection {
            
            print("User tapped on item \(indexPath.row)")
            guard let url = URL(string: listingData[indexPath.row].link) else {
                return
            }
            
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                
                UIApplication.shared.openURL(url)
                
            }
            
        }
        
        else {
            
            print("User tapped on item \(indexPath.row)")
        }
    }
    
    
    
    
}


import UIKit

//refresh
//        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Refresh List News")
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//
//        myCollectionView?.addSubview(refreshControl)

//Data for Listing
struct HomeArticleData {
    
    var contentID: String
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

struct HomeCompetitionData {
    
    var logo: String
    var name: String
    
}

class HomeViewController : UIViewController {
    
    var articleData: [HomeArticleData] = []
    var scoreBoardData: [HomeScoreBoardData] = []
    var competitionData: [HomeCompetitionData] = []
    
    var articleCollection: UICollectionView?
    var scoreBoardCollection: UICollectionView?
    var competitionCollection: UICollectionView?
    
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
                                           height: self.view.bounds.height/6)
        scoreBoardLayout.minimumLineSpacing = 20
        scoreBoardLayout.scrollDirection = .horizontal
        
        scoreBoardCollection = UICollectionView(frame: .zero, collectionViewLayout: scoreBoardLayout)
        scoreBoardCollection?.backgroundColor = UIColor.white
        
        scoreBoardCollection?.register(HomeScoreBoardCell.self, forCellWithReuseIdentifier: "HomeScoreBoardCell")
        scoreBoardCollection?.dataSource = self
        scoreBoardCollection?.delegate = self
        
        //MARK: News Listing Collection View
        let articleLayout = UICollectionViewFlowLayout()
        articleLayout.itemSize = CGSize(width: self.view.bounds.width,
                                        height: self.view.bounds.height/7)
        articleLayout.minimumLineSpacing = 25

        articleCollection = UICollectionView(frame: .zero, collectionViewLayout: articleLayout)
        articleCollection?.backgroundColor = UIColor.white
        
        articleCollection?.register(HomeArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        articleCollection?.dataSource = self
        articleCollection?.delegate = self
        
        //MARK: Competition Collection View
        
        let competitionLayout = UICollectionViewFlowLayout()
        competitionLayout.itemSize = CGSize(width: self.view.bounds.width/3,
                                           height: self.view.bounds.width/3)
        competitionLayout.minimumLineSpacing = 20
        competitionLayout.scrollDirection = .horizontal
        
        competitionCollection = UICollectionView(frame: .zero, collectionViewLayout: competitionLayout)
        competitionCollection?.backgroundColor = UIColor.white
        
        competitionCollection?.register(HomeCompetitionCell.self, forCellWithReuseIdentifier: "HomeCompetitionCell")
        competitionCollection?.dataSource = self
        competitionCollection?.delegate = self
        
        //MARK: Add layout and Subviews
        addSubviewsLayout()
        view.addSubview(articleCollection ?? UICollectionView())
        view.addSubview(scoreBoardCollection ?? UICollectionView())
        view.addSubview(competitionCollection ?? UICollectionView())
       
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //get data score board
        getScoreBoardData(compID: 0, date: "20220618")
        
        //get data home news
        getHomeListingData()
        
        //get home competition data
        getHomeCompetitionData()
    }
    
    //MARK: GET Data Functions
    
    //get data score board
    func getScoreBoardData(compID: Int, date: String) {
        
        QueryService.sharedService.get(MatchAPITarget.matchByDate(compID: String(compID), date: date)) {
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
       
            case .failure(let err):
                print(err)
                
            }
            
        }
        
    }
    
    //get data home news listing
    func getHomeListingData() {
        
        QueryService.sharedService.get(ContentAPITarget.home) {
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.contents {
                    
                    for i in contents {
                        
                        DispatchQueue.main.async {
                            
                            self?.articleData.append(HomeArticleData(contentID: String(i.contentID),
                                                                     avatar: i.avatar,
                                                                     title: i.title,
                                                                     author: i.publisherLogo,
                                                                     link: i.url))
                            
                            //Reload all collection data
                            self?.articleCollection?.reloadData()

                        }
                    }
                }
                
            case .failure(let err):
                print(err)
                
            }
        }
    }
    
    //get data home news listing
    func getHomeCompetitionData() {
        
        QueryService.sharedService.get(CompetitionAPITarget.hot) {
            
            [weak self]
            (result: Result<ResponseModel<CompetitionModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.soccerCompetitions {
                    
                    for i in contents {
                        
                        DispatchQueue.main.async {
                            
                            self?.competitionData.append(HomeCompetitionData(logo: i.competitionLogo, name: i.competitionName))
                            
                            //Reload all collection data
                            self?.competitionCollection?.reloadData()

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
        //Competition Collection
        
        competitionCollection?.frame = CGRect(x: 0,
                                              y: (scoreBoardCollection?.frame.maxY)! + 10 ,
                                              width: self.view.bounds.width,
                                              height: self.view.bounds.height / 3 - 100)
        
        //Listing Collection
    
        articleCollection?.frame = CGRect(x: 0,
                                          y: (competitionCollection?.frame.maxY)! + 10 ,
                                          width: self.view.bounds.width,
                                          height: self.view.bounds.height / 3 + 100)
        
    }

}


extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == articleCollection {
            
            print(articleData.count)
            return articleData.count
            
        } else if collectionView == scoreBoardCollection {
            
            return scoreBoardData.count
            
        } else if collectionView == competitionCollection {
            
            return competitionData.count
            
        }
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == articleCollection {
            
            let listingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
            
            listingCell.backgroundColor = UIColor.white
            listingCell.loadData(inputData: articleData[indexPath.row])
            
            return listingCell
            
            
        } else if collectionView == scoreBoardCollection{
            
            let scoreBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScoreBoardCell", for: indexPath) as! HomeScoreBoardCell
            
            scoreBoardCell.backgroundColor = UIColor.white
            scoreBoardCell.loadData(inputData: scoreBoardData[indexPath.row])
            
            return scoreBoardCell
            
        } else {
            
            let competitionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCompetitionCell", for: indexPath) as! HomeCompetitionCell
            
            competitionCell.backgroundColor = UIColor.white
            competitionCell.loadData(inputData: competitionData[indexPath.row])
            
            return competitionCell
            
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == articleCollection {
            
            print("User tapped on item \(indexPath.row)")
            //print("contentID: \(articleData[indexPath.row].contentID)")
            
            NotificationCenter.default.post(name: NSNotification.Name("HomeToArticel"), object: articleData[indexPath.row])
            
        }
        
        else {
            
            print("User tapped on item \(indexPath.row)")
            
        }
    }    
}


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
        scoreBoardLayout.minimumLineSpacing = 20
        scoreBoardLayout.scrollDirection = .horizontal
        
        scoreBoardCollection = UICollectionView(frame: .zero, collectionViewLayout: scoreBoardLayout)
        scoreBoardCollection?.backgroundColor = UIColor.white
        
        scoreBoardCollection?.register(HomeScoreBoardCell.self, forCellWithReuseIdentifier: "HomeScoreBoardCell")
        scoreBoardCollection?.dataSource = self
        scoreBoardCollection?.delegate = self
        
        //MARK: News Listing Collection View
        let articleLayout = UICollectionViewFlowLayout()
        articleLayout.minimumLineSpacing = 25

        articleCollection = UICollectionView(frame: .zero, collectionViewLayout: articleLayout)
        articleCollection?.backgroundColor = UIColor.white
        
        articleCollection?.register(HomeArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        articleCollection?.register(HomeCompetitionCollectionCell.self, forCellWithReuseIdentifier: "HomeCompCell")
        
        articleCollection?.dataSource = self
        articleCollection?.delegate = self
        
       
        
        //MARK: Add layout and Subviews
        addSubviewsLayout()
        view.addSubview(articleCollection ?? UICollectionView())
        view.addSubview(scoreBoardCollection ?? UICollectionView())
       
       
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //get data score board
        getScoreBoardData(compID: 0, date: "20220618")
        
        //get data home news
        getHomeArticelData()
        
        //get data competition
        getCompetitionData()
        
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
                        
                    }
                    
                    DispatchQueue.main.async {
    
                        self?.scoreBoardCollection?.reloadData()
                        
                    }
                    
                }
       
            case .failure(let err):
                print(err)
                
            }
            
        }
        
    }
    
    //get data home news listing
    func getHomeArticelData() {
        
        QueryService.sharedService.get(ContentAPITarget.home) {
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.contents {
                    
                    for i in contents {
                        
                        self?.articleData.append(HomeArticleData(contentID: String(i.contentID),
                                                                 avatar: i.avatar,
                                                                 title: i.title,
                                                                 author: i.publisherLogo,
                                                                 link: i.url))
                        
                    }
                    
                    DispatchQueue.main.async {
    
                        //Reload all collection data
                        self?.articleCollection?.reloadData()

                    }
                }
                
            case .failure(let err):
                print(err)
                
            }
        }
    }
    
    //get data competition
    func getCompetitionData() {
        
        QueryService.sharedService.get(CompetitionAPITarget.hot) {
            
            [weak self]
            (result: Result<ResponseModel<CompetitionModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.soccerCompetitions {
                    
                    for i in contents {
                        
                        self?.competitionData.append(HomeCompetitionData(logo: i.competitionLogo, name: i.competitionName))
                       
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
    
        articleCollection?.frame = CGRect(x: 0,
                                          y: (scoreBoardCollection?.frame.maxY)! + 10 ,
                                          width: self.view.bounds.width,
                                          height: self.view.bounds.height / 3 + 200)
        
    }

}

//MARK: Datasource Extension
extension HomeViewController: UICollectionViewDataSource {
    
    //Return Cells Number
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == articleCollection {
            
            return articleData.count
            
        } else if collectionView == scoreBoardCollection {
            
            return scoreBoardData.count
            
        }
        
        return 10
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == articleCollection {
            
            if indexPath.row == 2 {
                
                let competitionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCompCell", for: indexPath) as! HomeCompetitionCollectionCell
                
                competitionCell.backgroundColor = UIColor.white
                competitionCell.loadData(inputData: self.competitionData)
                
                return competitionCell
                
            } else {
                
                let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
                
                articelCell.backgroundColor = UIColor.white
                
                if indexPath.row > 2 {
                    
                    articelCell.loadData(inputData: articleData[indexPath.row-1])
                    
                } else {
                    
                    articelCell.loadData(inputData: articleData[indexPath.row])
                    
                }
                
               return articelCell
                
            }
             
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


//MARK: Delegate Extension
extension HomeViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == articleCollection {
            
            if indexPath.row != 2 {
                
                print("User tapped on item \(indexPath.row)")
                //print("contentID: \(articleData[indexPath.row].contentID)")
                
                NotificationCenter.default.post(name: NSNotification.Name("HomeToArticel"), object: articleData[indexPath.row])
                
                
            }
            
        }
        
        else {
            
            print("User tapped on item \(indexPath.row)")
            
        }
    }    
}

//MARK: Delegate Flow Layout extension
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == articleCollection {
            
            if indexPath.row != 2 {
                //articels size
     
                return CGSize(width: self.view.bounds.width,
                                                height: self.view.bounds.height/7)
                
            } else {
              
                //competition size
                return CGSize(width: self.view.bounds.width,
                                                height: self.view.bounds.height/4)
            }
            
        } else {
            
            //Hot match size
            return CGSize(width: self.view.bounds.width/1.5,
                                               height: self.view.bounds.height/6)
        }
           
    }
    
    
}


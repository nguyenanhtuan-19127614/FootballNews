
import UIKit

//refresh
//        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Refresh List News")
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//
//        myCollectionView?.addSubview(refreshControl)

//Data for Listing Articel
struct HomeArticleData {
    
    var contentID: String
    var avatar: String
    var title: String
    var author: String
    var link: String
  
}

//Data for Score Board
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

//Data for Competition Board
struct HomeCompetitionData {
    
    var logo: String
    var name: String
    
}

class HomeViewController : UIViewController {
    
    //Inex where score board and competition should be based on articels list
    let scoreBoardIndex = 0
    let competitionIndex = 4
    
    //Location of scoreboard and competiion
    var scoreBoardLocation: [Int] = [0]
    var competitionLocation: [Int] = [4]
    
    //query param
    var startArticel = 0
    var articelSize = 15
    
    //Data array
    var articleData: [HomeArticleData] = []
    var scoreBoardData: [HomeScoreBoardData] = []
    var competitionData: [HomeCompetitionData] = []
    
    //Main CollectionView
    var articleCollection: UICollectionView?
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        
        self.title = "Trang Chính"
        //MARK: Create customView
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.937, green: 0.933, blue: 0.957, alpha: 1).cgColor
    
        //MARK: News Listing Collection View
        
        //Custom CollectionView layout
        let articleLayout = UICollectionViewFlowLayout()
        articleLayout.minimumLineSpacing = 25
        
        //Custom CollectionView
        articleCollection = UICollectionView(frame: .zero, collectionViewLayout: articleLayout)
        articleCollection?.backgroundColor = UIColor.white
        articleCollection?.showsVerticalScrollIndicator = false
        
        //Register data for CollectionView
        articleCollection?.register(HomeArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        articleCollection?.register(HomeCompetitionCollectionCell.self, forCellWithReuseIdentifier: "HomeCompetitionColectionCell")
        articleCollection?.register(HomeScoreBoardCollectionCell.self, forCellWithReuseIdentifier: "HomeScoreBoardColectionCell")
        
        articleCollection?.dataSource = self
        articleCollection?.delegate = self
        
       
        
        //MARK: Add layout and Subviews
        addSubviewsLayout()
        view.addSubview(articleCollection ?? UICollectionView())
       
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //get data score board
        getScoreBoardData(compID: 0, date: "20220308")
        
        //get data home news
        getHomeArticelData()
        
        //get data competition
        getCompetitionData()
        
    }
    
    //MARK: GET Data Functions

    //get data home news listing
    func getHomeArticelData() {
        
        QueryService.sharedService.get(ContentAPITarget.home(start: String(startArticel),
                                                             size: String(articelSize))) {
            
            [weak self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.contents {
                    
                    if let dataNumbers = self?.articleData.count  {
                        
                        self?.scoreBoardLocation.append(dataNumbers + self!.scoreBoardIndex)
                        self?.competitionLocation.append(dataNumbers + self!.competitionIndex)
                        
                    }
           
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
      
        //Listing Collection
        articleCollection?.frame = CGRect(x: 0,
                                          y: 0 ,
                                          width: self.view.bounds.width,
                                          height: self.view.bounds.height)
    }

}

//MARK: Datasource Extension
extension HomeViewController: UICollectionViewDataSource {
    
    //Return Cells Number
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articleData.count
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if competitionLocation.contains(indexPath.row) {
            
            let competitionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCompetitionColectionCell", for: indexPath) as! HomeCompetitionCollectionCell
            
            competitionCell.backgroundColor = UIColor.white
            competitionCell.loadData(inputData: self.competitionData)
            
            return competitionCell
            
        } else if scoreBoardLocation.contains(indexPath.row) {
            
            let scoreBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScoreBoardColectionCell", for: indexPath) as! HomeScoreBoardCollectionCell
            
            scoreBoardCell.backgroundColor = UIColor.white
            scoreBoardCell.loadData(inputData: self.scoreBoardData)
            
            return scoreBoardCell
            
        } else {
            
            let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
            
            articelCell.backgroundColor = UIColor.white
            
            if indexPath.row != competitionIndex {
                
                articelCell.loadData(inputData: articleData[indexPath.row])
                
            }
           
            return articelCell
            
        }
    }
}


//MARK: Delegate Extension
extension HomeViewController: UICollectionViewDelegate {
    
    //Tap Event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != competitionIndex && indexPath.row != scoreBoardIndex {
            
            print("User tapped on item \(indexPath.row)")
            
            NotificationCenter.default.post(name: NSNotification.Name("HomeToArticel"), object: articleData[indexPath.row])            
            
        }
    }
    
    //Load More Data
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            
            startArticel += articelSize
           
            getHomeArticelData()
           
            
        }
    }
}

//MARK: Delegate Flow Layout extension
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if competitionLocation.contains(indexPath.row) {
            
            //competition size
            return CGSize(width: self.view.bounds.width,
                          height: self.view.bounds.height/4)
            
        } else if scoreBoardLocation.contains(indexPath.row) {
            
            //Hot match size
            return CGSize(width: self.view.bounds.width,
                          height: self.view.bounds.height/5)
            
        } else {
          
            //articel size
            return CGSize(width: self.view.bounds.width,
                          height: self.view.bounds.height/7)
        }
           
    }
    
}


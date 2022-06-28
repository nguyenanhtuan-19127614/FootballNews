
import UIKit

//refresh
//        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Refresh List News")
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//
//        myCollectionView?.addSubview(refreshControl)

// API main + (n API) => all APIs done => state = .loaded
//
//
//
//

//Passing data with delegate

enum HomeViewState {
    
    case loading
    case loaded
    case error
    
}

class HomeViewController : UIViewController, HomeDataSoureDelegate {
    
    
    //Delegate
    weak var delegate: ViewControllerDelegate?
    
    //ViewController State
    var state: HomeViewState = .loading
    
    // Datasource
    let dataSource = HomeDataSource()
    
    //Inex where score board and competition should be based on articels list
    let scoreBoardIndex = 0
    let competitionIndex = 4
    
    //Location of scoreboard and competiion
    var competitionLocation: [Int] = [4]
    
    //query param
    var startArticel = 0
    var articelSize = 15

    //Main CollectionView
    var homeCollection: UICollectionView = {
        
        //Custom CollectionView layout
        let articleLayout = UICollectionViewFlowLayout()
        articleLayout.sectionInsetReference = .fromSafeArea
        articleLayout.minimumLineSpacing = 25
        
        //Custom CollectionView
        let homeCollection = UICollectionView(frame: .zero, collectionViewLayout: articleLayout)
        homeCollection.backgroundColor = UIColor.white
        homeCollection.contentInsetAdjustmentBehavior = .always
        
        //Register data for CollectionView
        homeCollection.register(HomeArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        homeCollection.register(HomeCompetitionCollectionCell.self, forCellWithReuseIdentifier: "HomeCompetitionColectionCell")
        homeCollection.register(HomeScoreBoardCollectionCell.self, forCellWithReuseIdentifier: "HomeScoreBoardColectionCell")
        homeCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "HomeLoadMoreCell")
    
        
        
        return homeCollection
    }()
    
    
    //MARK: Delegation Function
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.homeCollection.reloadData()
            
        }
        
    }
    
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        //Add delegate for datasource
       
        dataSource.delegate = self
        self.title = "Trang Chính"
        //MARK: Create customView
        let view = UIView()

        //MARK: News Listing Collection View
       
        homeCollection.dataSource = self
        homeCollection.delegate = self
       
        
        //MARK: Add layout and Subviews
       
        view.addSubview(homeCollection )
       
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addSubviewsLayout()
        
        self.getScoreBoardData(compID: 0, date: "20220208")
        
        //get data home news
        self.getHomeArticelData()
        
        //get data competition
        self.getCompetitionData()
        
        
    }
    
    //MARK: GET Data Functions

    //get data home news listing
    func getHomeArticelData() {
        
        QueryService.sharedService.get(ContentAPITarget.home(start: startArticel,
                                                             size: articelSize)) {
            
            [unowned self]
            (result: Result<ResponseModel<ContentModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.contents {
                        
                    self.competitionLocation.append( self.dataSource.articelSize + self.competitionIndex)
                        
                   
                    var articelArray: [HomeArticleData] = []
                    for i in contents {
                        
                        articelArray.append(HomeArticleData(contentID: String(i.contentID),
                                                            avatar: i.avatar,
                                                            title: i.title,
                                                            author: i.publisherLogo,
                                                            link: i.url,
                                                            date: i.date))
                       
                    }
                    
                    self.dataSource.articleData.append(contentsOf: articelArray)
                    
                    if self.state == .loaded {
                        
                        DispatchQueue.main.async {
                            
                            self.homeCollection.reloadItems(at: self.homeCollection.indexPathsForVisibleItems)
                                       
                        }
    
                    } else {
                        
                        self.state = .loaded
                        
                    }

                }
                
            case .failure(let err):
                print("Error: \(err)")
                self.state = .error
                
            }
        }
        
    }
    
    //get data score board
    func getScoreBoardData(compID: Int, date: String) {
        
        QueryService.sharedService.get(MatchAPITarget.matchByDate(compID: String(compID),
                                                                  date: date,
                                                                  start: 0,
                                                                  size: 25)) {
            
            [unowned self]
            (result: Result<ResponseModel<MatchModel>, Error>) in
            switch result {
                
            case .success(let res):
                
                if let soccerMatch = res.data?.soccerMatch {
                    
                    var soccerMatchsArray: [HomeScoreBoardData] = []
                   
                    for i in soccerMatch {
                        
                        soccerMatchsArray.append(HomeScoreBoardData(
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
                    
                    self.dataSource.scoreBoardData.append(contentsOf: soccerMatchsArray)
                    
                }
       
            case .failure(let err):
                print(err)
                
            }
            
        }
        
    }
    
    //get data competition
    func getCompetitionData() {
        
        QueryService.sharedService.get(CompetitionAPITarget.hot) {
            
            [unowned self]
            (result: Result<ResponseModel<CompetitionModel>, Error>) in
            switch result {
            
            case .success(let res):
                
                if let contents = res.data?.soccerCompetitions {
                    
                    var competitionArray: [HomeCompetitionData] = []
                    for i in contents {
                        
                        competitionArray.append(HomeCompetitionData(logo: i.competitionLogo,
                                                                    name: i.competitionName))
                       
                    }
                    
                    self.dataSource.competitionData.append(contentsOf: competitionArray)
                }
                
            case .failure(let err):
                print(err)
                
            }
        }
    }
    
    //MARK: Function to add layout for subviews
    func addSubviewsLayout() {
      
        homeCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            homeCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            homeCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            homeCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            homeCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            
        ])
       
    }
    
    
}

//Source of truth
//Datasource: Store data [] -> signal -> CollectionView reload

//State: Loading -> Datasource update loading
//State: idle -> data -> Datasource


//MARK: Datasource Extension
extension HomeViewController: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if state == .loading {
             
            return 1
            
        } else if state == .loaded {
            
            return dataSource.articelSize
            
        } else {
            
            return 0
            
        }
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if state == .loading {
            
            let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLoadMoreCell", for: indexPath) as! LoadMoreIndicatorCell
            
            indicatorCell.indicator.startAnimating()
            return indicatorCell
         
            
        } else if state == .loaded {
            
            if competitionLocation.contains(indexPath.row) {
                
                let competitionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCompetitionColectionCell", for: indexPath) as! HomeCompetitionCollectionCell
                
                competitionCell.backgroundColor = UIColor.white
                
                DispatchQueue.main.async {
                    
                    [unowned self] in
                    competitionCell.loadData(inputData: self.dataSource.competitionData)
                    
                    
                }

                return competitionCell
                
            } else if indexPath.row == scoreBoardIndex {
                
                let scoreBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScoreBoardColectionCell", for: indexPath) as! HomeScoreBoardCollectionCell
                
                scoreBoardCell.backgroundColor = UIColor.white

                DispatchQueue.main.async {
                    
                    [unowned self] in
                    scoreBoardCell.loadData(inputData: self.dataSource.scoreBoardData)
                    
                }

               
                return scoreBoardCell
                
            } else if indexPath.row < dataSource.articelSize - 1  {
                
                let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
                
                articelCell.backgroundColor = UIColor.white
               
                articelCell.loadData(inputData: self.dataSource.articleData[indexPath.row])
            
                articelCell.layer.borderWidth = 0
               
                return articelCell
                
            } else {
                
                let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeLoadMoreCell", for: indexPath) as! LoadMoreIndicatorCell
                
                indicatorCell.indicator.startAnimating()
                return indicatorCell
                
            }
            
        }
        return UICollectionViewCell()
    }
}


//MARK: Delegate Extension
extension HomeViewController: UICollectionViewDelegate {
    
    //Tap Event
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(self.state == .loaded) {
            
            //Pass Data and call articelDetail View Controller
            if indexPath.row != competitionIndex && indexPath.row != scoreBoardIndex {
                
                print("User tapped on item \(indexPath.row)")
                
                
                let articelDetailVC = ArticelDetailController()
                self.delegate = articelDetailVC
                self.delegate?.passContentID(contentID: dataSource.articleData[indexPath.row].contentID)
                self.delegate?.passPublisherLogo(url: dataSource.articleData[indexPath.row].author)
                
                navigationController?.pushViewController(articelDetailVC, animated: true)
             
            }
            
        }
        
    }
    
    //Load More Data
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if dataSource.articleData.count == 0 {
            return
        }
        
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            
            startArticel += articelSize
                    
            //get data home news
            getHomeArticelData()
            
            
        }
    }

}

//MARK: Delegate Flow Layout extension
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if state == .loading {
            
            return CGSize(width: self.view.bounds.width ,
                          height: self.view.bounds.height)
        } else {
            
            if competitionLocation.contains(indexPath.row){
                
                //competition size
                return CGSize(width: self.view.bounds.width,
                              height: self.view.bounds.height/4)
                
            } else if indexPath.row == scoreBoardIndex  {
                
                //Hot match size
                return CGSize(width: self.view.bounds.width,
                              height: self.view.bounds.height/5)
                
            } else if indexPath.row < dataSource.articelSize - 1 || dataSource.articelSize == 0  {
        
                //articel size
                return CGSize(width: self.view.bounds.width,
                              height: self.view.bounds.height/7)
                
            } else {
                
                //load more animation cell size
                return CGSize(width: self.view.bounds.width,
                              height: self.view.bounds.height/25)
                
            }
            
        }
           
    }
    
}


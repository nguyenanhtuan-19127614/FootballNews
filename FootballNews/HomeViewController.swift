
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

enum ViewControllerState {
    
    case loading
    case loaded
    case error
    
}

class HomeViewController : UIViewController, DataSoureDelegate {
    
    //Delegate
    weak var delegate: ViewControllerDelegate?
   
    //ViewController State
    var state: ViewControllerState = .loading
    
    // Datasource
    let dataSource = HomeDataSource()
    
    //Inex where score board and competition should be based on articels list
    var scoreBoardExist: Bool = false
    var scoreBoardIndex = 0
    let competitionIndex = 4
    
    //Location of scoreboard and competiion
    var competitionLocation: [Int] = []
    
    //query param
    var startArticel = 0
    var articelSize = 20
    
    //Main CollectionView Layout
    var homeLayout = UICollectionViewFlowLayout()
    
    //Main CollectionView
    var homeCollection: UICollectionView = {
        
        //Custom CollectionView
        let homeCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        homeCollection.backgroundColor = UIColor.white
        homeCollection.contentInsetAdjustmentBehavior = .always
        
        //Register data for CollectionView
        homeCollection.register(HomeArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        homeCollection.register(HomeCompetitionCollectionCell.self, forCellWithReuseIdentifier: "HomeCompetitionColectionCell")
        homeCollection.register(HomeScoreBoardCollectionCell.self, forCellWithReuseIdentifier: "HomeScoreBoardColectionCell")
        homeCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "HomeLoadMoreCell")
        
        return homeCollection
        
    }()

    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        
        //Add delegate for datasource
        dataSource.delegate = self

        //MARK: Create customView
        let view = UIView()

        //MARK: News Listing Collection View
        
        homeCollection.dataSource = self
        homeCollection.delegate = self
       
      
        homeCollection.collectionViewLayout = homeLayout
        //MARK: Add layout and Subviews
       
        view.addSubview(homeCollection )
       
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addSubviewsLayout()
        
        //get data score board 
        self.getScoreBoardData(compID: 0, date: "20220211")
        
        //get data home news
        self.getHomeArticelData()
        
        //get data competition
        self.getCompetitionData()
        
        
    }
    //MARK: viewWillAppear() state
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //Custom navigation bar
 
        if #available(iOS 13.0, *) {
            
            let startColor = CGColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1)
            let middleColor = CGColor(red: 0.05, green: 0.39, blue: 0.59, alpha: 1)
            let endColor = CGColor(red: 0.04, green: 0.31, blue: 0.58, alpha: 1)
            
            navigationController?.navigationBar.setGradientBackground(colors: [startColor,middleColor,endColor])
            
        }
 
    }
    
    //Custom Layout
    override func viewDidLayoutSubviews() {
        
        homeLayout.sectionInsetReference = .fromSafeArea
        homeLayout.minimumLineSpacing = 25
       
    }
    
    
   
    //MARK: Delegation Function
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.homeCollection.reloadData()
            
        }
        
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
                        
                   
                    var articelArray: [HomeArticleModel] = []
                    for i in contents {
                        
                        articelArray.append(HomeArticleModel(contentID: String(i.contentID),
                                                            avatar: i.avatar,
                                                            title: i.title,
                                                            author: i.publisherLogo,
                                                            link: i.url,
                                                            date: i.date))
                       
                    }
                    
                    self.dataSource.articleData.append(contentsOf: articelArray)
                    
                    if self.state == .loaded {
                        
                        DispatchQueue.main.async {

                            self.homeCollection.reloadData()
                                       
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
                    
                    var soccerMatchsArray: [HomeScoreBoardModel] = []
                   
                    for i in soccerMatch {
                        
                        soccerMatchsArray.append(HomeScoreBoardModel(
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
                    
                    if dataSource.scoreBoardData.isEmpty {
                        
                        scoreBoardExist = false
                        return
                        
                    }
                    
                    scoreBoardExist = true
                    
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
                    
                    var competitionArray: [HomeCompetitionModel] = []
                    for i in contents {
                        
                        competitionArray.append(HomeCompetitionModel(logo: i.competitionLogo,
                                                                    name: i.competitionName))
                       
                    }
                    
                    self.dataSource.competitionData.append(contentsOf: competitionArray)
                    if competitionLocation.isEmpty {
                        
                        competitionLocation.append(self.competitionIndex)
                        return
                        
                    }
                    self.competitionLocation.append( self.dataSource.articelSize + self.competitionIndex)
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
            
            return dataSource.cellSize
            
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
                
            } else if indexPath.row == scoreBoardIndex && scoreBoardExist == true  {
                
                let scoreBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScoreBoardColectionCell", for: indexPath) as! HomeScoreBoardCollectionCell
                
                scoreBoardCell.backgroundColor = UIColor.white

                DispatchQueue.main.async {
                    
                    [unowned self] in
                    scoreBoardCell.loadData(inputData: self.dataSource.scoreBoardData)
                    
                }

               
                return scoreBoardCell
                
            } else if indexPath.row < dataSource.articelSize - 1{
                
                let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
                
                articelCell.backgroundColor = UIColor.white
               
                articelCell.loadData(inputData: self.dataSource.articleData[indexPath.row])
            
               
               
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
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
        
        if state == .loading || state == .error {
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
        } else {
            
            if competitionLocation.contains(indexPath.row){
                
                //competition size
                
                return CGSize(width: totalWidth,
                              height: totalHeight/4)
                
            } else if indexPath.row == scoreBoardIndex && scoreBoardExist == true  {
                
                //Hot match size
                return CGSize(width: totalWidth,
                              height: totalHeight/5)
                
            } else if indexPath.row < dataSource.articelSize - 1 {
        
                //articel size
                return CGSize(width: totalWidth,
                              height: totalHeight/7)
                
            } else {
                
                //load more animation cell size
                return CGSize(width: totalWidth,
                              height: totalHeight/24)
                
            }
            
        }
           
    }
    
}

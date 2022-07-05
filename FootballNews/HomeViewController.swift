
import UIKit
import Network

// API main + (n API) => all APIs done => state = .loaded
//
//
//
//

//Source of truth
//Datasource: Store data [] -> signal -> CollectionView reload

//State: Loading -> Datasource update loading
//State: idle -> data -> Datasource


//Passing data with delegate


class HomeViewController : UIViewController, DataSoureDelegate {
    
    // Internet Connection
    
    
    //Delegate
    weak var delegate: ViewControllerDelegate?
    
    //ViewController State
    var state: ViewControllerState = .loading
    
    // Datasource
    let dataSource = HomeDataSource()
    
    //Disk Caching
    lazy var diskCache = DiskCache()
    
    //ScoreBoard and competition Exist or not
    var scoreBoardExist: Bool = false
    var competitionExist: Bool = false
    
    //Index where score board and competition should be based on articels list
    var scoreBoardIndex = 0
    let competitionIndex = 4
    
    //Location and competiion
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
        homeCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "LoadMoreCell")
        homeCollection.register(ErrorOccurredCell.self, forCellWithReuseIdentifier: "ErrorCell")
        
        return homeCollection
        
    }()
    
    //MARK: Delegation Function
    
    func getData() {
        
        //Get offline data from disk if offline mode
        if state == .offline {
            diskCache.getData()
            return
        }
        //Get data from server
        self.getScoreBoardData(compID: 0, date: Date().getTodayAPIQueryString())
        
        //get data home news
        self.getHomeArticelData()
        
        //get data competition
        self.getCompetitionData()
        
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            
            self.homeCollection.reloadData()
            
        }
        
    }
    
    func stopRefresh() {
        
        DispatchQueue.main.async {
            
            self.homeCollection.refreshControl?.endRefreshing()
            
        }
        
    }
    
    func changeState(state: ViewControllerState) {
        
        self.state = state
        self.homeCollection.reloadData()
        
    }
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        
        //Add delegate for datasource
        dataSource.delegate = self
        
        //MARK: Create customView
        let view = UIView()
        view.backgroundColor = .white
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
        
        //Add Refresh control to homeCollection
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Đang Cập Nhật")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        homeCollection.refreshControl = refreshControl
        
        //Internet checking
       
        
        
        //get data score board
        self.getData()
        
    }
    
    //MARK: Refresh methods
    @objc func refresh() {
        
        if state == .offline {
            self.stopRefresh()
            return
        }
        
        self.startArticel = 0
        self.competitionLocation = []
        
        dataSource.refresh()
        
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
    
    //MARK: Function to add layout for subviews
    func addSubviewsLayout() {
        
        homeCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            homeCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            homeCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            homeCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            homeCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            
        ])
        
    }
    
    //MARK: Custom Layout
    override func viewDidLayoutSubviews() {
        
        homeLayout.sectionInsetReference = .fromSafeArea
        homeLayout.minimumLineSpacing = 20
        
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
                                                             publisherLogo: i.publisherLogo,
                                                             date: i.date))
                        
                    }
                    
                    self.dataSource.articleData.append(contentsOf: articelArray)
                    
                    //Load more case
                    if self.state == .loaded {
                        
                        DispatchQueue.main.async {
                            
                            self.homeCollection.reloadData()
                            
                        }
                        
                    } else {
                        //First time load
                        self.state = .loaded
                        
                    }
                    
                }
                
            case .failure(let err):
                print("Error: \(err)")
             
                self.state = .error
                
                DispatchQueue.main.async {
                    self.homeCollection.reloadData()
                }
                
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
                
                var soccerMatchsArray: [HomeScoreBoardModel] = []
                if let soccerMatch = res.data?.soccerMatch {
                    
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
                    
                }
                
                self.dataSource.scoreBoardData.append(contentsOf: soccerMatchsArray)
                if dataSource.scoreBoardData.isEmpty {
                    
                    scoreBoardExist = false
                    return
                    
                }
                
                scoreBoardExist = true
                
                
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
                    
                    //Check if competition exist
                    if dataSource.competitionData.isEmpty {
                        
                        competitionExist = false
                        return
                        
                    }
                    competitionExist = true
                    print("hi \(self.dataSource.competitionData)")
                    //Add location for competition cell
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
    
    
    
}

//MARK: Datasource Extension
extension HomeViewController: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if state == .offline {
            return self.diskCache.homeArticelData.count
        }
        
        if state == .loading || state == .error {
            
            return 1
            
        } else {
            
            return dataSource.cellSize
            
        }
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if state == .offline {
            let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
            
            articelCell.backgroundColor = UIColor.white
            articelCell.loadData(inputData: self.diskCache.homeArticelData[indexPath.row])
            
            return articelCell
        }
        
        guard state == .loaded else {
            
            
            if state == .loading {
                //Loading State
                let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreIndicatorCell
                
                indicatorCell.indicator.startAnimating()
                return indicatorCell
                
            } else {
                //Error State
                let errorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCell", for: indexPath) as! ErrorOccurredCell
                errorCell.delegate = self
                return errorCell
                
            }
        }
        
        //Loaded State
        if competitionLocation.contains(indexPath.row)  && competitionExist == true  {
            
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
            
            let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreIndicatorCell
            
            indicatorCell.indicator.startAnimating()
            return indicatorCell
            
        }
    }
}


//MARK: Delegate Extension
extension HomeViewController: UICollectionViewDelegate {
    
    //Tap Event
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if state == .offline {
            
            let articelDetailVC = OfflineArticelDetailController()
            self.delegate = articelDetailVC
            let contentID = diskCache.homeArticelData[indexPath.row].contentID
            let detail = diskCache.articelDetail[contentID]
            self.delegate?.passArticelDetail(detail: detail)
            
            navigationController?.pushViewController(articelDetailVC, animated: true)
            
        }
        
        if self.state == .loaded {
            
            //Pass Data and call articelDetail View Controller
            if indexPath.row != competitionIndex && indexPath.row != scoreBoardIndex {
                
                let articelDetailVC = ArticelDetailController()
                self.delegate = articelDetailVC
                self.delegate?.passContentID(contentID: dataSource.articleData[indexPath.row].contentID)
                self.delegate?.passPublisherLogo(url: dataSource.articleData[indexPath.row].publisherLogo)
                
                navigationController?.pushViewController(articelDetailVC, animated: true)
                
            }
            
        }
        
    }
    
    //Load More Data
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        
        if dataSource.articleData.count == 0 || state == .offline {
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
        
        if state == .offline {
            
            return CGSize(width: totalWidth,
                          height: totalHeight/7)
            
        }
        
        if state == .loading || state == .error {
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
        } else {
            
            if competitionLocation.contains(indexPath.row)  && competitionExist == true {
                
                //competition size
                
                return CGSize(width: totalWidth,
                              height: totalHeight/5)
                
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


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
    
    //status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    // Internet Connection
    
    // Datasource
    let dataSource = HomeDataSource()
    
    //App Nav Controller delegate
    weak var navDelegate: AppNavigationController?
    
    //Main CollectionView Layout
    var homeLayout = UICollectionViewFlowLayout()
    
    //Main CollectionView
    var homeCollection: UICollectionView = {
        

        //Custom CollectionView
        let homeCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        homeCollection.backgroundColor = UIColor.white
        homeCollection.contentInsetAdjustmentBehavior = .always
        
        //Register data for CollectionView
        homeCollection.register(ArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        homeCollection.register(HomeCompetitionCollectionCell.self, forCellWithReuseIdentifier: "HomeCompetitionColectionCell")
        homeCollection.register(HomeScoreBoardCollectionCell.self, forCellWithReuseIdentifier: "HomeScoreBoardColectionCell")
        homeCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "LoadMoreCell")
        homeCollection.register(ErrorOccurredCell.self, forCellWithReuseIdentifier: "ErrorCell")
        homeCollection.register(SeparateCell.self, forCellWithReuseIdentifier: "SeparateCell")
        
        return homeCollection
        
    }()
    
    //MARK: Delegation Function
    
    func getData() {
        
        //Get off data from disk if offline mode
        if dataSource.state == .offline {
            dataSource.diskCache.getData()
            return
        }
        //Get data from server
        self.dataSource.getScoreBoardData(compID: 0, date: "0")
        
        //get data home news
        self.dataSource.getHomeArticelData()
        
        //get data competition
        self.dataSource.getCompetitionData()
        
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
        
        self.dataSource.state = state
        self.homeCollection.reloadData()
        
    }
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()
        self.view.backgroundColor = .white
        //Add delegate for datasource
        dataSource.delegate = self
        
        //MARK: Create customView
        let view = UIView()
        view.backgroundColor = .white
        //MARK: News Listing Collection View
        
        homeCollection.dataSource = self
        homeCollection.delegate = self
        
        homeCollection.collectionViewLayout = homeLayout
        
        //MARK: Add Subviews
        view.addSubview(homeCollection)
        
        self.view = view
        
    }
    //MARK:
   
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        
        //add layout
        addSubviewsLayout()
        homeLayout.sectionInsetReference = .fromSafeArea
        homeLayout.minimumLineSpacing = 15
        
        //Add Refresh control to homeCollection
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Đang Cập Nhật")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        homeCollection.refreshControl = refreshControl
        
        //Internet checking
        
        //Push Offline alert notification if offline Mode
        connectionErrorAlert()
        
        //get data score board
        self.getData()
        
    }
    
    //MARK: Refresh methods
    @objc func refresh() {
        
        if dataSource.state == .offline {
            
            self.stopRefresh()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.connectionErrorAlert()
            }
            
            return
        }
        
        self.dataSource.startArticel = 0
       
        dataSource.refresh()
      
        
    }
    
    //MARK: Offline alert notification
    func connectionErrorAlert() {
        
        if dataSource.state == .offline {
            
            let notification = ConnectionErrorNotification()
            self.present(notification, animated: false, completion: nil)
           
        }
        
    }
    //MARK: viewDidLayoutSubviews state
   
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
      
        //Set titleview of navigation bar
        
        let titleView = CustomTitleView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: (self.navigationController?.navigationBar.bounds.width ?? 0)/1.3,
                                                      height: (self.navigationController?.navigationBar.bounds.height ?? 0)/1.3))
        
        titleView.loadData(image: UIImage(named: "TitleView2"))
        self.tabBarController?.navigationItem.titleView = titleView
        
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
        
        //Status bar
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
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

//MARK: Datasource Extension
extension HomeViewController: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let state = dataSource.state
        
        switch state {
        case .loading:
            
            return 1
            
        case .loaded:
            
            return dataSource.cellSize 
            
        case .error:
            
            return 1
            
        case .offline:
            
            return self.dataSource.diskCache.homeArticelData.count
            
        }

        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch self.dataSource.state {
            
        case .offline:
            
            guard let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as? ArticleCell else {
                break
            }

            articelCell.backgroundColor = UIColor.white
            articelCell.loadData(inputData: self.dataSource.diskCache.homeArticelData[indexPath.row])
            
            return articelCell
            
        case .loading:
            
            guard let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as? LoadMoreIndicatorCell else {
                break
            }
            
            indicatorCell.indicator.startAnimating()
            return indicatorCell
            
        case .error:
            
            guard let errorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCell", for: indexPath) as? ErrorOccurredCell else {
                break
            }
            
            errorCell.delegate = self
            return errorCell
                
        case .loaded:
            
            //Loaded State
            if dataSource.competitionIndex == indexPath.row  &&
               dataSource.competitionExist == true  {
                
                guard let competitionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCompetitionColectionCell", for: indexPath) as? HomeCompetitionCollectionCell else {
                    break
                }
                
                competitionCell.backgroundColor = UIColor.white
                competitionCell.delegate = self
                
                DispatchQueue.main.async {
                    
                    [weak self] in
                    if let self = self {
                        
                        competitionCell.loadData(inputData: self.dataSource.competitionData)
                        
                    }
                   
                    
                }
                
                return competitionCell
                
            } else if indexPath.row == dataSource.scoreBoardIndex &&
                      dataSource.scoreBoardExist == true  {
                
                guard let scoreBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScoreBoardColectionCell", for: indexPath) as? HomeScoreBoardCollectionCell else {
                    
                    break
                    
                }
                
                scoreBoardCell.backgroundColor = UIColor.white
                scoreBoardCell.delegate = self
                
                DispatchQueue.main.async {
                    
                    [weak self] in
                    if let self = self {
                        scoreBoardCell.loadData(inputData: self.dataSource.scoreBoardData)
                    }
        
                }
        
                return scoreBoardCell
                
            } else if indexPath.row < dataSource.articleData.count{
                
                
                guard let data = self.dataSource.articleData[indexPath.row] else {
                    
                    guard let separateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeparateCell", for: indexPath) as? SeparateCell else {
                        break
                    }
                    
                    return separateCell
                    
                }
            
                guard let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as? ArticleCell else {
                    break
                }
                
                
                articelCell.backgroundColor = UIColor.white
                articelCell.loadData(inputData: data)
               
                return articelCell
                
            } else {
                
                guard let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as? LoadMoreIndicatorCell else {
                    break
                }
                
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
    
    func competitionBoardClick(index: Int) {
        
        navDelegate?.hideSideMenu()
        
        ViewControllerRouter.shared.routing(to: .detailCompetition(dataComp: dataSource.competitionData[index]))
        
    }
    
    func scoreBoardClick(index: Int) {
        
        navDelegate?.hideSideMenu()
        
        ViewControllerRouter.shared.routing(to: .detailMatch(dataMatch: dataSource.scoreBoardData[index]))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        navDelegate?.hideSideMenu()
        
        if (dataSource.competitionIndex == indexPath.row && dataSource.competitionExist) ||
            (indexPath.row == dataSource.scoreBoardIndex && dataSource.scoreBoardExist) {
            
          return
            
        }
        
        let state = dataSource.state
        
        switch state {
            
        case .loading:
            
            return
            
        case .loaded:
            
            ViewControllerRouter.shared.routing(to: .detailArticle(dataArticle: dataSource.articleData[indexPath.row]))
            
        case .error:
            
            return
            
        case .offline:
            
            let header = dataSource.diskCache.homeArticelData[indexPath.row]
            let contentID = header.contentID
           
            let detail = dataSource.diskCache.articelDetail[contentID]
            ViewControllerRouter.shared.routing(to: .detailArticleOffline(dataArticle: detail,
                                                                          headerData: header))
            
        }
        
    }
    
    //Load More Data
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
  
        if dataSource.articleData.count == 0 || dataSource.state == .offline {
            return
        }
        
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
    
            dataSource.startArticel += dataSource.articelLoadSize
            //get data home news
            dataSource.getHomeArticelData()
 
        }
    }
    
}

//MARK: Delegate Flow Layout extension
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
        
        let state = dataSource.state
        
        switch state {
        case .loading:
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
            
        case .loaded:
            
            if dataSource.competitionIndex == indexPath.row  &&
               dataSource.competitionExist == true {
                
                //competition size
                
                return CGSize(width: totalWidth,
                              height: totalHeight/4)
                
            } else if indexPath.row == dataSource.scoreBoardIndex &&
                      dataSource.scoreBoardExist == true  {
                
                //Hot match size
                return CGSize(width: totalWidth,
                              height: totalHeight/4.5)
                
            } else if indexPath.row < dataSource.articleData.count {
                
                //separate size
                if dataSource.articleData[indexPath.row] == nil {
                    return CGSize(width: totalWidth,
                                 height: 6)
                }
                //article size
                return CGSize(width: totalWidth,
                              height: totalHeight/7)
                
            } else {
                
                //load more animation cell size
                return CGSize(width: totalWidth,
                              height: totalHeight/24)
                
            }
            
        case .error:
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
            
        case .offline:
            
            return CGSize(width: totalWidth,
                          height: totalHeight/7)
            
        }
        
        
    }
    
}


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
    
    // Datasource
    let dataSource = HomeDataSource()

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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
    
    //MARK: Add Observers
    
    //Func to addObserver of NotificationCenter
    func addObservers() {
        
        //Evetn click item of score board
        NotificationCenter.default
                          .addObserver(self,
                                       selector: #selector(scoreBoardClick(_:)),
                         name: NSNotification.Name ("ScoreBoardCollectionClickItem"), object: nil)
        
    }
    
    //Observer function
    @objc func scoreBoardClick(_ notification: Notification) {
        
        guard let index = notification.object as? Int else {
            return
        }
        
        let matchDetailVC = MatchDetailController()
        self.delegate = matchDetailVC
        delegate?.passHeaderData(scoreBoard: dataSource.scoreBoardData[index])
        navigationController?.pushViewController(matchDetailVC, animated: true)
        
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
        
        //MARK: Add observers
        self.addObservers()
        
        //MARK: Add Subviews
        view.addSubview(homeCollection)
        
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
        
        //Push Offline alert notification
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
        navigationController?.navigationBar.barStyle = .black
        
        //Back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
     
    }
    
    //MARK: Function to add layout for subviews
    func addSubviewsLayout() {
        
        homeCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            homeCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            homeCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            homeCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            homeCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            
        ])
        
    }
    
    //MARK: Custom Layout
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        homeLayout.sectionInsetReference = .fromSafeArea
      
    }
 
    
    
}

//MARK: Datasource Extension
extension HomeViewController: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let state = dataSource.state
        
        if state == .offline {
            
            return self.dataSource.diskCache.homeArticelData.count
            
        }
        
        if state == .loading || state == .error {
            
            return 1
            
        } else {
            
            return dataSource.cellSize
            
        }
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.dataSource.state == .offline {
            let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
            
            articelCell.backgroundColor = UIColor.white
            articelCell.loadData(inputData: self.dataSource.diskCache.homeArticelData[indexPath.row])
            
            return articelCell
        }
        
        guard self.dataSource.state == .loaded else {
            
            
            if self.dataSource.state == .loading {
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
        if dataSource.competitionLocation.contains(indexPath.row)  &&
           dataSource.competitionExist == true  {
            
            let competitionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCompetitionColectionCell", for: indexPath) as! HomeCompetitionCollectionCell
            
            competitionCell.backgroundColor = UIColor.white
            
            DispatchQueue.main.async {
                
                [weak self] in
                if let self = self {
                    
                    competitionCell.loadData(inputData: self.dataSource.competitionData)
                    
                }
               
                
            }
            
            return competitionCell
            
        } else if indexPath.row == dataSource.scoreBoardIndex &&
                  dataSource.scoreBoardExist == true  {
            
            let scoreBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScoreBoardColectionCell", for: indexPath) as! HomeScoreBoardCollectionCell
            
            scoreBoardCell.backgroundColor = UIColor.white
      
            DispatchQueue.main.async {
                
                [weak self] in
                if let self = self {
                    scoreBoardCell.loadData(inputData: self.dataSource.scoreBoardData)
                }
    
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
        
        let state = dataSource.state
        if state == .loaded || state == .offline{
            
            //Pass Data and call articelDetail View Controller
            if (dataSource.competitionLocation.contains(indexPath.row) && dataSource.competitionExist) ||
                (indexPath.row == dataSource.scoreBoardIndex && dataSource.scoreBoardExist) {
                
              return
                
            }
            
            let articelDetailVC = ArticelDetailController()
         
            if state == .offline {
                articelDetailVC.state = .offline
                self.delegate = articelDetailVC
                let contentID = dataSource.diskCache.homeArticelData[indexPath.row].contentID
                let detail = dataSource.diskCache.articelDetail[contentID]  
                self.delegate?.passArticelDetail(detail: detail)
                
                
            } else {
                
                self.delegate = articelDetailVC
                self.delegate?.passContentID(contentID: dataSource.articleData[indexPath.row].contentID)
                self.delegate?.passPublisherLogo(url: dataSource.articleData[indexPath.row].publisherLogo)
                
            }
  
            navigationController?.pushViewController(articelDetailVC, animated: true)
        }
        
    }
    
    //Load More Data
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        
        if dataSource.articleData.count == 0 || dataSource.state == .offline {
            return
        }
        
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            
           
            dataSource.startArticel += dataSource.articelSize
         
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
        
        if state == .offline {
            
            return CGSize(width: totalWidth,
                          height: totalHeight/7)
            
        }
        
        if state == .loading || state == .error {
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
        } else {
            
            if dataSource.competitionLocation.contains(indexPath.row)  &&
               dataSource.competitionExist == true {
                
                //competition size
                
                return CGSize(width: totalWidth,
                              height: totalHeight/5)
                
            } else if indexPath.row == dataSource.scoreBoardIndex &&
                      dataSource.scoreBoardExist == true  {
                
                //Hot match size
                return CGSize(width: totalWidth,
                              height: totalHeight/6.5)
                
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

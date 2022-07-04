
import UIKit


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

class OfflineHomeViewController : UIViewController, DataSoureDelegate {
    
    func reloadData() {
        return
    }
    
    func changeState(state: ViewControllerState) {
        return
    }
    
    
    //Delegate
    weak var delegate: ViewControllerDelegate?
   
    //ViewController State
    var state: ViewControllerState = .offline
    
    // Datasource from diskcache
    let diskCache = DiskCache()

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

        return homeCollection
        
    }()
    
    //MARK: Delegation Function
    
    func getData() {
        
        //get data home news
        self.getOfflineData()
   
    }
    
    
    //MARK: loadView() state
    override func loadView() {
        
        super.loadView()

        //MARK: Create customView
        let view = UIView()

        //MARK: News Listing Collection View
        
        homeCollection.dataSource = self
        homeCollection.delegate = self
       
      
        homeCollection.collectionViewLayout = homeLayout
        //MARK: Add layout and Subviews
       
        view.addSubview(homeCollection)
       
        self.view = view
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addSubviewsLayout()
       
        //get data score board
        self.getData()
        
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
            homeCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
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
    func getOfflineData() {
        
        diskCache.getData()
        
    }

}

//MARK: Datasource Extension
extension OfflineHomeViewController: UICollectionViewDataSource {
    
    //Return Cells Numbers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.diskCache.homeArticelData.count
        
    }
    
    //Return Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as! HomeArticleCell
        
        articelCell.backgroundColor = UIColor.white
        print(self.diskCache.homeArticelData[indexPath.row].avatar)
        articelCell.loadData(inputData: self.diskCache.homeArticelData[indexPath.row])
        
        return articelCell
    }
}


//MARK: Delegate Extension
extension OfflineHomeViewController: UICollectionViewDelegate {
    
    //Tap Event
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let articelDetailVC = OfflineArticelDetailController()
        self.delegate = articelDetailVC
        //self.delegate?.passContentID(contentID: diskCache.homeArticelData[indexPath.row].contentID)
        let contentID = diskCache.homeArticelData[indexPath.row].contentID
        self.delegate?.passArticelDetail(detail: diskCache.articelDetail[contentID] ?? nil)
        navigationController?.pushViewController(articelDetailVC, animated: true)
        
    }
    
    //Load More Data
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        return
        
    }

}

//MARK: Delegate Flow Layout extension
extension OfflineHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
        
        //articel size
        return CGSize(width: totalWidth,
                      height: totalHeight/7)
           
    }
    
}

//
//  SearchArticleViewController.swift
//  FootballNews
//
//  Created by LAP13606 on 18/07/2022.
//

import UIKit


class SearchArticleViewController: UIViewController, DataSoureDelegate {
    
    //status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
    //Search Controller
    let searchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setShowsCancelButton(false, animated: false)
        
        let placeHolderText = "Tìm kiếm"
        
        if #available(iOS 13.0, *) {
            
            //Custom place holder
            searchController.searchBar.searchTextField.attributedPlaceholder =  NSAttributedString(string: placeHolderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            //Custom Icon
            searchController.searchBar.searchTextField.leftView?.tintColor = .white
        }
        
        
        //Custom Textfield
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            
            textField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            //textField.addVibrancyEffect()
            textField.textColor = .white
            
        }
   
        return searchController
    }()
    
    //Datasource
    let dataSource = SearchArticleDataSource()
    
    //Main CollectionView Layout
    var searchLayout = UICollectionViewFlowLayout()
    
    //Main Collection
    var searchCollection: UICollectionView = {
        
        //Custom CollectionView
        let searchCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        searchCollection.backgroundColor = UIColor.white
        searchCollection.contentInsetAdjustmentBehavior = .always
        
        //Register data for CollectionView
        searchCollection.register(ArticleCell.self, forCellWithReuseIdentifier: "HomeArticleCell")
        searchCollection.register(LoadMoreIndicatorCell.self, forCellWithReuseIdentifier: "LoadMoreCell")
        searchCollection.register(ErrorOccurredCell.self, forCellWithReuseIdentifier: "ErrorCell")
        
        return searchCollection
        
    }()
    
    
    //MARK: Delegation Function
    func reloadData() {
        
        DispatchQueue.main.async {
            self.searchCollection.reloadData()
        }
      
    }
    
    func changeState(state: ViewControllerState) {
        self.dataSource.state = state
    }
    
    func getData() {
        
        dataSource.getHotArticelData()
        
    }
    
    //MARK: viewDidLoad() state
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //MARK: Search Controller
        // delete back button
    
        //Add search bar
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        self.navigationItem.titleView = searchController.searchBar

        definesPresentationContext = true
       
        //MARK: Add delegate for datasource
        dataSource.delegate = self
        
        //MARK: Create customView
        
        view.backgroundColor = .white
        //MARK: News Listing Collection View
        
        searchCollection.dataSource = self
        searchCollection.delegate = self
        
        searchCollection.collectionViewLayout = searchLayout
        
        //MARK: Add Subviews
        view.addSubview(searchCollection)
        
        //MARK: Add Layout
        addSubviewsLayout()
        searchLayout.sectionInsetReference = .fromSafeArea
        searchLayout.minimumLineSpacing = 15
        self.getData()
    }
    
    //MARK: viewWillAppear() state
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Custom Navigation Bars
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //Custom navigation bar
       
        let startColor = UIColor(red: 0.27, green: 0.63, blue: 0.62, alpha: 1).cgColor
        let middleColor = UIColor(red: 0.05, green: 0.39, blue: 0.59, alpha: 1).cgColor
        let endColor = UIColor(red: 0.04, green: 0.31, blue: 0.58, alpha: 1).cgColor

        navigationController?.navigationBar.setGradientBackground(colors: [startColor,middleColor,endColor])
        
        //Status bar
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
    }
    
    //MARK: Function to add layout for subviews
    func addSubviewsLayout() {
        
        searchCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            searchCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            searchCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            searchCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            
        ])
        
    }
}
//MARK: Collection
//MARK: Delegate Extension
extension SearchArticleViewController: UICollectionViewDelegate {
    
    //Tap Event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let state = dataSource.state
        
        switch state {
            
        case .loading:
            
            return
            
        case .loaded:
            
            if dataSource.showContent == .hotArticles {
                
                ViewControllerRouter.shared.routing(to: .detailArticle(dataArticle: dataSource.hotArticles[indexPath.row]))
                
            } else {
                
                ViewControllerRouter.shared.routing(to: .detailArticle(dataArticle: dataSource.searchArticles[indexPath.row]))
                
            }
           
        case .error:
            
            return
            
        case .offline:
            
            return
            
        }
        
    }
    
    //Load More Data
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
  
        if dataSource.hotArticles.count == 0 || dataSource.state == .offline {
            return
        }
        
        if dataSource.showContent == .searchArticles {
            return
        }
        
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
    
            dataSource.startArticel += dataSource.articelLoadSize
            //get data home news
            dataSource.getHotArticelData()
 
        }
    }
}

//MARK: Datasource Extension
extension SearchArticleViewController: UICollectionViewDataSource {
    
    //Number of cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let state = dataSource.state
        
        switch state {
            
        case .loading:
            
            return 1
            
        case .loaded:
            
            if dataSource.showContent == .hotArticles {
                return dataSource.hotArticles.count + 1
            }
            return dataSource.searchArticles.count
            
        case .error:
            
            return 1
            
        case .offline:
            
            return 1
            
        }
        
    }
    
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch dataSource.state {
            
        case .loading:
            guard let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as? LoadMoreIndicatorCell else {
                break
            }
            
            indicatorCell.indicator.startAnimating()
            return indicatorCell
            
        case .loaded:
            
            guard let articelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeArticleCell", for: indexPath) as? ArticleCell else {
                break
            }
            
            guard let indicatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as? LoadMoreIndicatorCell else {
                break
            }
            
            
            articelCell.backgroundColor = UIColor.white
            
            if dataSource.showContent == .hotArticles {
                
                //load more
                if indexPath.row >= self.dataSource.hotArticles.count {
                    
                    indicatorCell.indicator.startAnimating()
                    return indicatorCell
                    
                }
                //hot articles
                if let data = self.dataSource.hotArticles[indexPath.row] {
                    articelCell.loadData(inputData: data)
                    return articelCell
                }
            
            } else {
                
                //search articles
                if let data = self.dataSource.searchArticles[indexPath.row] {
                    articelCell.loadData(inputData: data)
                    return articelCell
                }
            
            }
            
           
            indicatorCell.indicator.startAnimating()
            return indicatorCell
        
        case .error:
            
            guard let errorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCell", for: indexPath) as? ErrorOccurredCell else {
                break
            }
            
            errorCell.delegate = self
            return errorCell
            
        case .offline:
            guard let errorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCell", for: indexPath) as? ErrorOccurredCell else {
                break
            }
            
            errorCell.delegate = self
            return errorCell
            
        }
        
        fatalError()
    }
    
    
}
    
//MARK: Delegate Flow Layout extension
extension SearchArticleViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height
        
        switch dataSource.state {
        case .loading:
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
        case .loaded:
            
            if dataSource.showContent == .hotArticles && indexPath.row >= self.dataSource.hotArticles.count {
                
                //load more animation cell size
                return CGSize(width: totalWidth,
                              height: totalHeight/24)
                
            }
            
            return CGSize(width: totalWidth,
                          height: totalHeight/7)
            
        case .error:
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
            
        case .offline:
            
            return CGSize(width: totalWidth ,
                          height: totalHeight)
            
        }
    }
}

//MARK: Search Bar
extension SearchArticleViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        return
    }
    
    
}

extension SearchArticleViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            
            dataSource.searchArticles = []
            dataSource.showContent = .hotArticles
            self.reloadData()
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        
        var searchData: [HomeArticleModel?] = []
        for article in dataSource.hotArticles {
          
            if article?.title.contains(searchText) == true{
                searchData.append(article)
            }
            
        }
        
        dataSource.showContent = .searchArticles
        dataSource.searchArticles = searchData
        self.reloadData()
        
    }
}

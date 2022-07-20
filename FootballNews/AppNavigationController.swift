//
//  AppNavigationController.swift
//  FootballNews
//
//  Created by LAP13606 on 16/07/2022.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    let tabController = UITabBarController()
    
    let homeVC = HomeViewController()
    let videoVC = UpComingViewController()
    let trendingVC = UpComingViewController()
    let ultilityVC = UpComingViewController()
    
    let sideMenuVC = SideMenuViewController()
    
    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ViewControllerRouter.shared.setUpNavigationController(self)
        
        //MARK: Home View Controller
        //        homeVC.changeState(state: .offline)
        //        ImageDownloader.sharedService.offlineMode = true
        let imgHome = UIImage(named: "newsIcon")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let homeIcon = UITabBarItem(title: "Tin Tức", image: imgHome, tag: 0)
        homeVC.tabBarItem = homeIcon
        homeVC.navDelegate = self
        //MARK: Video View Controller
        let imgVideo = UIImage(named: "videoIcon")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let videoIcon = UITabBarItem(title: "Video", image: imgVideo, tag: 1)
        videoVC.tabBarItem = videoIcon
        
        
        //MARK: Trending View Controller
        let imgChart = UIImage(named: "chartIcon")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let chartIcon = UITabBarItem(title: "Xu Hướng", image: imgChart, tag: 2)
        trendingVC.tabBarItem = chartIcon
        trendingVC.view.backgroundColor = .white
        
        //MARK: Ultility View Controller
        let imgMenu = UIImage(named: "menu")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let menuIcon = UITabBarItem(title: "Tiện Ích", image: imgMenu, tag: 3)
        
        ultilityVC.tabBarItem = menuIcon
        ultilityVC.view.backgroundColor = .white
        
        //MARK: Tab bar controller
        tabController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabController.addChild(homeVC)
        tabController.addChild(videoVC)
        tabController.addChild(trendingVC)
        tabController.addChild(ultilityVC)
        
        //MARK: Navigation Controller
        self.navigationBar.isTranslucent = false
        self.pushViewController(tabController, animated: false)
        
    }
    
    //MARK: viewDidLayoutSubviews state
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        // add side menu
        let screenFrame = self.view.frame
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
        self.navigationBar.frame.height
        
        sideMenuVC.view.frame = CGRect(x: -screenFrame.width,
                                       y: topBarHeight,
                                       width: screenFrame.width * 0.7,
                                       height: screenFrame.height-topBarHeight)
        
        UIApplication.shared.windows.last?.addSubview(sideMenuVC.view)
        
    }
    
    //MARK: viewWillAppear state
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Nav bar
        
        //Right Icon
        //search icon
        let imgSearch = UIImage(named: "searchIcon")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let iconSearch = UIBarButtonItem(image: imgSearch,
                                         style: .plain,
                                         target: self,
                                         action: #selector(pushSearchViewController))
        iconSearch.tintColor = .white
        tabController.navigationItem.rightBarButtonItem = iconSearch
        
        //Left Icon
        //menu icon
        let imgMenu = UIImage(named: "menu")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let iconMenu = UIBarButtonItem(image: imgMenu,
                                       style: .plain,
                                       target: self,
                                       action: #selector(controlSideMenu))
        iconMenu.tintColor = .white
        tabController.navigationItem.leftBarButtonItem = iconMenu
        
    }
    
    
    //MARK: Search
    @objc func pushSearchViewController() {
        
        self.hideSideMenu()
        ViewControllerRouter.shared.routing(to: .searchArticle)
        
    }
    
    
    //delegate func
    func hideSideMenu() {
        
        sideMenuVC.hide()
        //set hide frame
        
        homeVC.view.removeBlurEffect()
        videoVC.view.removeBlurEffect()
        trendingVC.view.removeBlurEffect()
        ultilityVC.view.removeBlurEffect()
        
    }
    
    //MARK: Nav button Action
    @objc func controlSideMenu() {
        
        if sideMenuVC.isShow == false {
            
            //show side menu
            sideMenuVC.show()
            //Set blur effect
            homeVC.view.addBlurEffect()
            videoVC.view.addBlurEffect()
            trendingVC.view.addBlurEffect()
            ultilityVC.view.addBlurEffect()
            
        } else {
            
            //hide side menu
            sideMenuVC.hide()
            //Remove blur effect
            homeVC.view.removeBlurEffect()
            videoVC.view.removeBlurEffect()
            trendingVC.view.removeBlurEffect()
            ultilityVC.view.removeBlurEffect()
            
        }
        
    }
    
    
}

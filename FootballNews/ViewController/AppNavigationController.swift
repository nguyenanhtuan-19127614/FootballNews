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
    let videoVC = UIViewController()
    let trendingVC = UIViewController()
    let ultilityVC = UIViewController()
    
    let sideMenuVC = SideMenuViewController()
    
    
    override func viewDidLoad() {
        
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
                                       width: screenFrame.width/1.5,
                                       height: screenFrame.height)
      
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
                                         action: nil)
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
    
    //delegate func
    func hideSideMenu() {
        
        var frameHome = homeVC.view.frame
        var frameVideo = videoVC.view.frame
        var frameTrending = trendingVC.view.frame
        var frameUltility = ultilityVC.view.frame
        var frameTabbar = tabController.tabBar.frame
        
        sideMenuVC.hide()
        //set hide frame
        frameHome.origin.x = 0
        frameTabbar.origin.x = 0
        frameVideo.origin.x = 0
        frameTrending.origin.x = 0
        frameUltility.origin.x = 0
        
        //Animation
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .transitionFlipFromLeft,
                       animations: {[unowned self] in
            
            homeVC.view.frame = frameHome
            tabController.tabBar.frame = frameTabbar
           
        }, completion: nil)
        
    }
    
    //MARK: Nav button Action
    @objc func controlSideMenu() {
        
        var frameHome = homeVC.view.frame
        var frameVideo = videoVC.view.frame
        var frameTrending = trendingVC.view.frame
        var frameUltility = ultilityVC.view.frame
        var frameTabbar = tabController.tabBar.frame
        
        if sideMenuVC.isShow == false {
            
            sideMenuVC.show()
            //set show frame
            frameHome.origin.x = sideMenuVC.view.frame.width
            frameTabbar.origin.x = sideMenuVC.view.frame.width
            frameVideo.origin.x = sideMenuVC.view.frame.width
            frameTrending.origin.x = sideMenuVC.view.frame.width
            frameUltility.origin.x = sideMenuVC.view.frame.width
            
        } else {
           
            sideMenuVC.hide()
            //set hide frame
            frameHome.origin.x = 0
            frameTabbar.origin.x = 0
            frameVideo.origin.x = 0
            frameTrending.origin.x = 0
            frameUltility.origin.x = 0
            
        }
        
        //Animation
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .transitionFlipFromLeft,
                       animations: {[unowned self] in
            
            homeVC.view.frame = frameHome
            tabController.tabBar.frame = frameTabbar
           
        }, completion: nil)
    }
    
    
}

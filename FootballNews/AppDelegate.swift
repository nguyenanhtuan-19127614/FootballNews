//
//  AppDelegate.swift
//  FootballNews
//
//  Created by LAP13606 on 06/06/2022.
//

import UIKit


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var window: UIWindow?
    var navController: UINavigationController?
    var tabController: UITabBarController?
    
    var homeVC = HomeViewController()
    var videoVC = UIViewController()
    var trendingVC = UIViewController()
    var ultilityVC = UIViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //MARK: Home View Controller
        //homeVC.changeState(state: .offline)
        //ImageDownloader.sharedService.offlineMode = true
        let imgHome = UIImage(named: "newsIcon")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let homeIcon = UITabBarItem(title: "Tin Tức", image: imgHome, tag: 0)
        homeVC.tabBarItem = homeIcon

        //MARK: Video View Controller
        let imgVideo = UIImage(named: "videoIcon")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let videoIcon = UITabBarItem(title: "Video", image: imgVideo, tag: 1)
        videoVC.tabBarItem = videoIcon
        videoVC.view.backgroundColor = .white
        
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
        tabController = UITabBarController()
        tabController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabController?.addChild(homeVC)
        tabController?.addChild(videoVC)
        tabController?.addChild(trendingVC)
        tabController?.addChild(ultilityVC)
    
        //MARK: Navigation Controller
        navController = UINavigationController(rootViewController: tabController ?? homeVC)
        navController?.navigationBar.isTranslucent = false
      
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
        
    }
    
   
}




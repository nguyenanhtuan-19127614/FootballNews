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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //MARK: Home View Controller
        //homeVC.changeState(state: .offline)
        //ImageDownloader.sharedService.offlineMode = true
        let img = UIImage(named: "newsIcon")?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        let homeIcon = UITabBarItem(title: "Tin Tức", image: img, tag: 0)
        homeVC.tabBarItem = homeIcon
//
//        let upcomingVC = UIViewController()
//        upcomingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
//
        //MARK: Tab bar controller
        tabController = UITabBarController()
        tabController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tabController?.addChild(homeVC)
        
//        tabController?.addChild(upcomingVC)
        
        //MARK: Navigation Controller
        navController = UINavigationController(rootViewController: tabController ?? homeVC)
        navController?.navigationBar.isTranslucent = false
     
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
        
    }
    
}




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
    let homeVC = HomeViewController()
    let articelDetailVC = ArticelDetailController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let tabController = UITabBarController()
        tabController.addChild(homeVC)
        
        navController = UINavigationController(rootViewController: tabController)
       
        
        navController?.navigationBar.isTranslucent = false
        navController?.navigationBar.backgroundColor = .white
        navController?.title = "Trang Chính"
        
        addObservers()
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
        
    }
    
    func addObservers() {
        
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(toArticel(_:)),
                                       name: NSNotification.Name ("HomeToArticel"), object: nil)
        articelDetailVC.addObservers()
        
    }
    
    @objc func toArticel(_ notification: Notification){
        
        navController?.pushViewController(articelDetailVC, animated: true)
        
    }
    
}


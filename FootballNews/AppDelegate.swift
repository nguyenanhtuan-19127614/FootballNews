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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = HomeViewController()
        
        let tabController = UITabBarController()
        tabController.addChild(homeVC)
        
        let navController = UINavigationController(rootViewController: tabController)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = .white
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
    
}


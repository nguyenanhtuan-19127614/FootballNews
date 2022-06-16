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
        let viewController = ViewController()
        
        let tabController = UITabBarController()
        tabController.addChild(viewController)
        
        let navController = UINavigationController(rootViewController: tabController)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = .orange
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
    
}


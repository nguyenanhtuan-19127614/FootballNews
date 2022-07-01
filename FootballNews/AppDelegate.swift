//
//  AppDelegate.swift
//  FootballNews
//
//  Created by LAP13606 on 06/06/2022.
//

import UIKit

enum ViewControllerState {
    
    case loading
    case loaded
    case error
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?
    let homeVC = HomeViewController()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
    
        navController = UINavigationController(rootViewController: homeVC)
        navController?.navigationBar.backgroundColor = .white
        navController?.navigationBar.isTranslucent = false
        
        //Drop shadow for navigation bar
        navController?.navigationBar.layer.masksToBounds = false
        navController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navController?.navigationBar.layer.shadowOpacity = 0.8
        navController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navController?.navigationBar.layer.shadowRadius = 2
        
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
        
    }
 
}




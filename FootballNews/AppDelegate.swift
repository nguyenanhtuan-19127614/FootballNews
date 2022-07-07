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
    case offline
    
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var window: UIWindow?
    var navController: UINavigationController?
    var homeVC = HomeViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
       
        navController = UINavigationController(rootViewController: homeVC)
        homeVC.state = .offline
        ImageDownloader.sharedService.offlineMode = true
        navController?.navigationBar.backgroundColor = .white
        navController?.navigationBar.isTranslucent = false
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
        
    }
 
}




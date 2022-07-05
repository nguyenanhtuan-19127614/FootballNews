//
//  AppDelegate.swift
//  FootballNews
//
//  Created by LAP13606 on 06/06/2022.
//

import UIKit
import Network

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
        navController?.navigationBar.backgroundColor = .white
        navController?.navigationBar.isTranslucent = false
        
        //Drop shadow for navigation bar
        navController?.navigationBar.addShadow(color: UIColor.lightGray.cgColor,
                                               opacity: 0.5,
                                               offset: CGSize(width: 0, height: 1.0),
                                               radius: 2)
        
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
        
    }
 
}




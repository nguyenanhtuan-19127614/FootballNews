//
//  UINavigationControllerExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 15/07/2022.
//

import UIKit

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    open override var childForStatusBarStyle: UIViewController? {
            return topViewController
    }
}

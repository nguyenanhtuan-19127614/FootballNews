//
//  ViewControllerDelegate.swift
//  FootballNews
//
//  Created by LAP13606 on 28/06/2022.
//

import Foundation

protocol ViewControllerDelegate: AnyObject {
    
    //pass Content ID (use for articelDetail)
    func passContentID(contentID: String)
    //pass Publisher Logo (use for articelDetail)
    func passPublisherLogo(url: String)
    
    
}

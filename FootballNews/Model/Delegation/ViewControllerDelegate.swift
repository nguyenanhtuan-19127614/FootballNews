//
//  ViewControllerDelegate.swift
//  FootballNews
//
//  Created by LAP13606 on 28/06/2022.
//

import Foundation

protocol ViewControllerDelegate: AnyObject {
    
    //MARK: ArticelDetail
    //pass Content ID
    func passContentID(contentID: String)
    //pass Publisher Logo
    func passPublisherLogo(url: String)
    //pass detail articel
    func passArticelDetail(detail: ArticelDetailModel?)
    
    //MARK: MatchDetail
    //func pass header data
    func passHeaderData(scoreBoard: HomeScoreBoardModel?)
    
}

//Optionnal Protocol Function
extension ViewControllerDelegate {
    
    //pass Content ID (use for articelDetail)
    func passContentID(contentID: String) {}
    //pass Publisher Logo (use for articelDetail)
    func passPublisherLogo(url: String) {}
    //pass detail articel (use for articelDetailOffline)
    func passArticelDetail(detail: ArticelDetailModel?){}
    //func pass header data
    func passHeaderData(scoreBoard: HomeScoreBoardModel?){}
}

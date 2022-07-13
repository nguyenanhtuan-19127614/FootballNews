//
//  TeamDetailDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 12/07/2022.
//

import UIKit

enum TeamDetailContent {
    
    case news
    case ranking
    
}

class TeamDetailDataSource {
    
    weak var delegate: DataSoureDelegate?
    
    var lock = NSLock()
    
    //Content To Show
    var selectedContent: TeamDetailContent = .news
    
    //State
    var state: ViewControllerState = .loading
    
    //Header Info Data
    var headerData: TeamInfoData?
}

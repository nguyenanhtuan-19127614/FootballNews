//
//  CompetitionDetailDataSource.swift
//  FootballNews
//
//  Created by LAP13606 on 12/07/2022.
//

import Foundation

class CompetitionDetailDataSource {
    
    weak var delegate: DataSoureDelegate?
    
    //Contain to show
    var selectedContent: CompetitionDetailContent = .news

    //State
    var state: ViewControllerState = .loading
}

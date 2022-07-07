//
//  DataSourceDelegate.swift
//  FootballNews
//
//  Created by LAP13606 on 28/06/2022.
//

import Foundation

protocol DataSoureDelegate: AnyObject {
    
    func reloadData()
    func changeState(state: ViewControllerState)
    func getData()
    func stopRefresh()
    
    //Change Content (Use for match detail VC)
    func changeContentMatchDetail(content: MatchDetailContent)
}

//Optionnal Protocol Function
extension DataSoureDelegate {
    
    func getData() {}
    func stopRefresh() {}
    
    func changeContentMatchDetail(content: MatchDetailContent){}
}

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
    func storeData()
    
    func stopRefresh()
    
}

//Optionnal Protocol Function
extension DataSoureDelegate {
    
    func stopRefresh() {}
    func storeData() {}
    
}

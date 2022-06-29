//
//  CustomArray.swift
//  FootballNews
//
//  Created by LAP13606 on 29/06/2022.
//

import Foundation

class CustomArray<T: Equatable> {
    
    private var arr: [T]
    private let lockQueue = DispatchQueue(label:"LockQueue", attributes: .concurrent)
    
    var count: Int {
        get {
            return arr.count
        }
    }
    
    var last: T? {
        get {
            return arr.last
        }
    }
    
    init() {
        arr = []
    }
    
    func addHead(_ value: T){

        arr.insert(value, at: 0)
        
    }
    
    func removeLast() {
        
        arr.removeLast()

    }
    
    func moveToHead(_ value: T) {
        
        for (index, object) in arr.enumerated() {
            
            if value == object {
                arr.remove(at: index)
                self.addHead(value)
            }
            
        }
        
    }
}

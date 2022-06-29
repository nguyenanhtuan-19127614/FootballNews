//
//  LRUCache.swift
//  FootballNews
//
//  Created by LAP13606 on 28/06/2022.
//

import Foundation



class LRUCache <Key:Hashable, Value> {
    
    private struct CacheValue: Equatable {
        
        static func == (lhs: LRUCache.CacheValue, rhs: LRUCache.CacheValue) -> Bool {
            return lhs.key == rhs.key
        }
        
        
        var value: Value
        let key: Key

    }
    
    private let lockQueue = DispatchQueue(label:"LockQueue", attributes: .concurrent)
    
    //Array store key orderedly by accessed numbers
    private var array: [Key] = []
    
    //Dict will store value by key, use to look up and access data
    private var nodesDict: [Key: CacheValue] = [:]
    
    private let sizeLimit: Int
    
    init(size: Int) {
        
        if size < 0 {
            
            self.sizeLimit = 0
            return
            
        }
        self.sizeLimit = size

    }
    
    func addValue(value: Value, key: Key) {
        
        lockQueue.sync(flags: [.barrier]) {
        
            //Create Cache value and Node
            let cacheValue = CacheValue(value: value, key: key)
            
            // Add value to linkedlist and dictionary
            if let existedValue = nodesDict[key] {
                
                array.moveToHead(existedValue.key)
               
            } else {
               
                if array.count == sizeLimit {
                    
                    if let lastKey = array.last {
                        
                        nodesDict.removeValue(forKey: lastKey)
                        
                    }
                    
                    array.removeLast()
                    
                }
                
                array.addHead(cacheValue.key)
                nodesDict[key] = cacheValue
                print("dictsize: \(nodesDict.count)")
                
            }
       
        }
      
    }
    
    func getValue(key: Key) -> Value? {
        
        lockQueue.sync {
            
           
            guard let existedValue = nodesDict[key] else {
                return nil
            }
            
            array.moveToHead(existedValue.key)
        
            return existedValue.value
           
        }
       
        
    }

}

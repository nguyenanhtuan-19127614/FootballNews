//
//  LRUCache.swift
//  FootballNews
//
//  Created by LAP13606 on 28/06/2022.
//

import Foundation



class LRUCache <Key:Hashable, Value> {
    
    struct CacheValue: Equatable {
        
        static func == (lhs: LRUCache.CacheValue, rhs: LRUCache.CacheValue) -> Bool {
            return lhs.key == rhs.key
        }
        
        
        var value: Value
        let key: Key

    }
    
    private let lockQueue = DispatchQueue(label:"LockQueue", attributes: .concurrent)
    
    //Array store data orderedly by accessed numbers

    let array = CustomArray<CacheValue>()
    //Dict will store value by key, use to look up and access data
    var nodesDict: [Key: CacheValue] = [:]
    
    //var nodesDict = ThreadSafeDictionary<Data, String>()
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
            [unowned self] in
            //Create Cache value and Node
            let cacheValue = CacheValue(value: value, key: key)
            
            // Add value to linkedlist and dictionary
            if let existedValue = nodesDict[key] {
                
                array.moveToHead(existedValue)
               
            } else {
               
                if array.count == sizeLimit {
                    
                    if let lastKey = array.last {
                        
                        nodesDict.removeValue(forKey: lastKey.key)
                        
                    }
                    
                    array.removeLast()
                    
                }
                
                array.addHead(cacheValue)
                nodesDict[key] = cacheValue
                print("dictsize: \(nodesDict.count)")
                
            }
       
        }
      
    }
    
    func getValue(key: Key) -> Value? {
        
        lockQueue.sync {
            
            guard let value = nodesDict[key] else {
                return nil
            }
            
            array.moveToHead(value)
        
            return value.value
           
        }
       
        
    }

}

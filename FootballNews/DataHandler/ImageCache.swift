//
//  ImageCache.swift
//  NetworkManager
//
//  Created by LAP13606 on 07/06/2022.
//

import Foundation

//Class summary: Custom class NSCache
//Support?
//Use?
//

final class Cache<Key: Hashable, Value> {
    
    //Contasnt
    let countLimit = 10
    let costLimit = 1024 * 1024 * 3
        
    //real Cache
    private let wrappedCache = NSCache<WrappedKey, WrappedValue>()
    
    //Initialization
    init() {
        
    }
    
    //
    func insertValue() {
        
        
    }
    
    //
    func getValue() {
        
        
    }
    
    //
    func removeValue() {
        
        
    }
    
    //
    func clearCache() {
        
        
    }
    
    //
//    subscript (key: String) -> Value? {
//        
//        get { }
//        
//        set{}
//        
//    }
}

private extension Cache {
    
    //Class to wrap Key
    final class WrappedKey: NSObject {
        
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            return self.key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            
            guard let value = object as? WrappedKey else {
                return false
            }
                            
            return value.key == key
                        
        }
    }
    
    //class to wrap value
    final class WrappedValue: NSObject {
        
        let value: Value
        
        init(value: Value) {
            self.value = value
        }

    }
    
}

 

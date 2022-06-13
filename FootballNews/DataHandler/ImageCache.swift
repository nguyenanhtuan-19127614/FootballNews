//
//  ImageCache.swift
//  NetworkManager
//
//  Created by LAP13606 on 07/06/2022.
//

import Foundation
import UIKit
//Class summary: Custom class NSCache
//Support?
//Use?
//

class ImageCache {
    
    //Singleton
    static var sharedCache = ImageCache()
    private init() {}
    
    //Cache config
    private let lock = NSLock()
    private let countLimit = 20
    //private let memoryLimit = 1024 * 1024 * 5
    
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = self.countLimit
        //cache.totalCostLimit = self.memoryLimit
        
        return cache
        
    }()
    
    func getCache() -> NSCache<AnyObject, AnyObject> {
        
        return imageCache
        
    }
    func addImage(imgData: Data?, url: String) {
        
        guard let imgData = imgData else {
            return
        }
        
        lock.lock()
        defer {
            
            lock.unlock()
            
        }
        
        imageCache.setObject(imgData as AnyObject, forKey: url as AnyObject)

    }
    
    func removeImage(url: String) {
        
        lock.lock()
        defer {
            
            lock.unlock()
            
        }
        imageCache.removeObject(forKey: url as AnyObject)
        
    }
    
    func removeAll() {
        
        lock.lock()
        defer {
            
            lock.unlock()
            
        }
        imageCache.removeAllObjects()
        
    }
    
    subscript (_ key: String) -> Data? {
        
        get {
            
            return imageCache.object(forKey: key as AnyObject) as? Data
            
        }
        
        set {
            
            addImage(imgData: newValue, url: key)
            
        }
        
    }
}

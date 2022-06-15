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
    static var shared = ImageCache()
    private init() {}
    
    //Cache config
    private let countLimit = 20
    private let memoryLimit = 1024 * 1024 * 5
    
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = self.countLimit
        cache.totalCostLimit = self.memoryLimit
        
        return cache
        
    }()
    
    
    func getCache() -> NSCache<AnyObject, AnyObject> {
        
        return imageCache
        
    }
    func addImage(imgData: Data?, url: String) {
        
        guard let imgData = imgData else {
            return
        }
        
        //cost of image base on size
        let cost: Int = imgData.count
        //store image to cache
        imageCache.setObject(imgData as AnyObject, forKey: url as AnyObject, cost: cost)

    }
    
    func removeImage(url: String) {
        
        imageCache.removeObject(forKey: url as AnyObject)
        
    }
    
    func removeAll() {
        
        imageCache.removeAllObjects()
        
    }
    
    func getImageData(url: String) -> Data? {
        
        return imageCache.object(forKey: url as AnyObject) as? Data
        
    }
    
}

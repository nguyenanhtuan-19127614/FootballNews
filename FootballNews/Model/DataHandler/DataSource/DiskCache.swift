//
//  DiskCache.swift
//  FootballNews
//
//  Created by LAP13606 on 04/07/2022.
//

import Foundation

enum DiskCacheKey: String {
    
    case homeArticel
    case articelDetail
    
}

class DiskCache {
    
    let userDefault = UserDefaults.standard
    //Store Home Article list Data
    var homeArticelData: [HomeArticleModel] = [] 
    //Store Articel Detail as: [contentID: articelDetail]
    var articelDetail: [String: ArticelDetailModel] = [:] 
    
    init() {
        
        userDefault.register(
            defaults: [
                "homeArticel": true,
                "articelDetail": true
            ]
        )
        
    }
    //Cache array Data
    func cacheData<T: Codable>(data: [T], key: DiskCacheKey) {
        
        do {
            
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(data)
            
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: key.rawValue)
            
            
        } catch {
            
            print("Unable to Encode Note (\(error))")
            
        }
        
    }
    //Cache normal data
    func cacheData<T: Codable>(data: T, key: DiskCacheKey) {
        
        do {
            
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(data)
            
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: key.rawValue)
            
            
        } catch {
            
            print("Unable to Encode Note (\(error))")
            
        }
        
    }
    
    func getData() {
        
        //Load home articel data
        if let homeData = userDefault.object(forKey: DiskCacheKey.homeArticel.rawValue) as? Data {
            
            let decoder = JSONDecoder()
            if let savedData = try? decoder.decode([HomeArticleModel].self, from: homeData) {
                
                homeArticelData = savedData
                
            }
        }
        
        //Load articel detail data
        if let articelData = userDefault.object(forKey: DiskCacheKey.articelDetail.rawValue) as? Data {
            
            let decoder = JSONDecoder()
            if let savedData = try? decoder.decode([String:ArticelDetailModel].self, from: articelData) {
                
                articelDetail = savedData
                
            }
        }
    }
    
    
    
}

//
//  DiskCache.swift
//  FootballNews
//
//  Created by LAP13606 on 04/07/2022.
//

import Foundation
import UIKit
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
            
            print("Unable to Encode (\(error))")
            
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
            
            print("Unable to Encode (\(error))")
            
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
    
    //Save Image Data to disk
    func saveImageToDisk(imageName: String, image: UIImage) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        if let jpgData = image.jpegData(compressionQuality: 0.5) {
            
            let path = documentsDirectory.appendingPathComponent(URL(fileURLWithPath: imageName).lastPathComponent )
        
            do {
                
                try jpgData.write(to: path)
                
            } catch let err {
                
                print(err)
                
            }
            
        }
    }
    
    //Download First, than save Image Data to disk
    
    func downloadAndsaveImageToDisk(url: String) {
        
        ImageDownloader.sharedService.download(url: url) {
            
            [unowned self]
            result in
            switch result {
                
            case .success(let image):
                
                guard let image = image else {
                    return
                }
                self.saveImageToDisk(imageName: url, image: image)
                
                
            case .failure( _):
                return
                
            }
        }
        
    }
    
    //Load Image Data From Disk
    func loadImageFromDisk(imageName: String) -> UIImage? {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        let filePathName = URL(fileURLWithPath: imageName).lastPathComponent
        let imageUrl = documentsDirectory.appendingPathComponent(filePathName)
        
        do {
            
            let imageData = try Data(contentsOf: imageUrl)
            return UIImage(data: imageData)
            
        } catch {
            //print("Error loading image : \(error)")
            return nil
        }
        
    }
    
    //Remove image data from disk
    func removeImageFromDisk(fileName: String) {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        let filePathName = URL(fileURLWithPath: fileName).lastPathComponent
        let fileURL = documentsDirectory.appendingPathComponent(filePathName)
        
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
            
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }
    }
    
    //Remove all images data from disk
    func removeAllImageFromDisk() {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        do {
            print("paths: \(documentsDirectory.absoluteString)")
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: documentsDirectory.path)
            
            for fileName in fileNames {
                
                let filePath = URL(fileURLWithPath: documentsDirectory.absoluteString).appendingPathComponent(fileName).absoluteURL
                try FileManager.default.removeItem(at: filePath)
                
            }
            
        } catch let removeError{
            print("couldn't remove files at path", removeError)
        }
    }
}

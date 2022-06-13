//
//  ImageDownloader.swift
//  NetworkManager
//
//  Created by LAP13606 on 07/06/2022.
//

import Foundation
import UIKit

//Class summary
//Support
//Use

//MARK: Class custom Operation
class NetworkDownloadOperation: Operation {
    
    var response: Response?
    var url: String = ""
    
    var downloader: ImageDownloader
    
    init(_ manager: ImageDownloader) {
        
        downloader = manager
        
    }
    
    func setupOperation(url: String) {
        
        self.url = url
        
    }
    
    override func main() {
    
        if isCancelled {
            
            return
            
        }
        
        do {
        
            self.response = try self.downloader.networkManager.callApi(self.url, .GET, nil)
            
        } catch {
            
            print(error.localizedDescription)
            
        }
    
    }
}

//MARK: Class Image Downloader
class ImageDownloader:  NetworkManagerProtocol {

    //Singleton
    static let sharedService = ImageDownloader()
    
    private init() {
        
        //Create Delegate
        networkManager.delegate = self
        
        //Config Operation Queue
        operationQueue.maxConcurrentOperationCount = 5
        
        let dispatchQueue = DispatchQueue(label: "downloadQueue", qos: .utility, attributes: .concurrent)
        operationQueue.underlyingQueue = dispatchQueue
        
    }
    //Operation queue to manage download
    let operationQueue = OperationQueue()
    
    //Base delegation class
    let networkManager = NetworkManager()
    

    
    //MARK: Main function, use this for download
    func download (url: String,
             method: HttpMethod = .GET,
             queryItems: [String: String]? = nil,
             completion: @escaping ( Result<Data,Error> ) -> Void ) {
        
        //Check if image is in cache
        if let imageCache = ImageCache.sharedCache[url] {
            
            print("Image is already in cache")
            completion(.success(imageCache))
            return
            
        }
        
        let customOperation = NetworkDownloadOperation(self)
        customOperation.setupOperation(url: url)
        
        //Completion block, execute after operation main() done
        customOperation.completionBlock = {
            
            if customOperation.isCancelled {
                
                completion(.failure(ManagerErrors.OperationCancel))
                
            }
            
            guard let response = customOperation.response else {
                
                completion(.failure(ManagerErrors.BadData))
                return
                
            }
            
            //Store image data to cache
            
            if let data = response._data {
                
                ImageCache.sharedCache[url] = data
                completion(.success(data))
                
            }

        }
        
        operationQueue.addOperation(customOperation)
        
    }
    
}

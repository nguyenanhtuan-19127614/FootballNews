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
class NetworkDownloadOperation: CustomOperation {
    
    override func main() {
        
        if isCancelled {
            
            self.response = nil
            return
            
        }
        
        ImageDownloader.sharedService.startCallApi(self.url, .GET, session: self.session) { [weak self] result in
            
            switch result {
                
            case .success(let res):
                
                self?.response = res
               
       
            case .failure(let err):
                print(err)
                self?.response = nil
            
            }
            
            self?.finish()

        }

    }
}

//MARK: Class Image Downloader
class ImageDownloader:  NetworkManager {

    //Singleton
    static let sharedService = ImageDownloader()
    
    //Constant (Use to config sessoin)
    private let timeoutForRequest = TimeInterval(30)
    private let timeoutForResource = TimeInterval(60)
    
    private let sessionConfig = URLSessionConfiguration.default
    
    var downloadSession: URLSession?
    
    //Operation queue to manage download
    let operationQueue = OperationQueue()
    
    //Private Init
    override private init() {
        
        //Create session
        sessionConfig.timeoutIntervalForRequest = timeoutForRequest
        sessionConfig.timeoutIntervalForResource = timeoutForResource
        
        self.downloadSession = URLSession(configuration: sessionConfig,
                                  delegate: nil,
                                  delegateQueue: nil)
        
        //Config Operation Queue
        operationQueue.maxConcurrentOperationCount = 5
        
        let dispatchQueue = DispatchQueue(label: "downloadQueue", qos: .utility, attributes: .concurrent)
        operationQueue.underlyingQueue = dispatchQueue
        
    }
    
    
    
    //MARK: Main function, use this for download
    func download (url: String,
             method: HttpMethod = .GET,
             queryItems: [String: String]? = nil,
             completion: @escaping ( Result<Data,Error> ) -> Void ) {
        
        //Check if image is in cache
        if let imageCache = ImageCache.shared.getImageData(url: url) {
            
            print("Image is already in cache")
            completion(.success(imageCache))
            return
            
        }
        
        guard let downloaddSession = downloadSession else {
            completion(.failure(ManagerErrors.NullSession))
            return
        }
        
       
        let customOperation = NetworkDownloadOperation(url: url, session: downloaddSession )

        
        //Completion block, execute after operation main() done
        customOperation.completionBlock = {
            
            [weak customOperation] in
            guard let customOperation = customOperation else {
                return
            }
            if customOperation.isCancelled {
                
                completion(.failure(ManagerErrors.OperationCancel))
                
            }
            
            guard let response = customOperation.response else {
                
                completion(.failure(ManagerErrors.BadData))
                return
                
            }
            
            //Store image data to cache
            if let data = response._data {
   
                ImageCache.shared.addImage(imgData: data, url: url)
                completion(.success(data))
                
            }

        }
        
        operationQueue.addOperation(customOperation)
        
    }

}

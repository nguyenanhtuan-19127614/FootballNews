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
        
        ImageDownloader.sharedService.startCallApi(self.url, session: self.session) {
            
            [weak self] result in

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
class ImageDownloader {

    //Singleton
    static let sharedService = ImageDownloader()
    
    //Image Cache
    private let imageCache = ImageCache()
    
    //Constant (Use to config sessoin)
    private let timeoutForRequest = TimeInterval(30)
    private let timeoutForResource = TimeInterval(60)
    
    private let sessionConfig = URLSessionConfiguration.default
    
    var downloadSession: URLSession?
    
    //Operation queue to manage download
    let operationQueue = OperationQueue()
    
    //Private Init
    private init() {
        
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
    
    //startCallApi
    func startCallApi (_ url: String,
                       session: URLSession,
                       completion: @escaping (Result<Response, Error>) -> Void) {
        
        //Create URL Components
        guard let urlComponent = URLComponents(string: url) else {
            
            completion(.failure(ManagerErrors.BadURL))
            return
            
        }
        
        //Create URL
        let url = urlComponent.url!
        // Create a request URL
        let request = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: request) {
            

            (data, response, error) in
                                         
            guard let response = response else {
                
                completion(.failure(ManagerErrors.BadResponse))
                return
                
            }
        
            guard let data = data else {

                if let error = error {
            
                    completion(.failure(error))
            
                }
                
                return
                
            }
            
            let responseBody = Response(_data: data, _response: response, _error: error)
            
            completion(.success(responseBody))
           
        }
        
        dataTask.resume()
        
    }
    
    //MARK: Main function, use this for download
    func download (url: String,
                   completion: @escaping ( Result<UIImage?,Error> ) -> Void ) {

        //Check if image is in cache
        if let imageCache = imageCache.getImageData(url: url) {
            
            print("Image is already in cache")
            completion(.success(UIImage(data: imageCache)))
            return
            
        }
        
        guard let downloaddSession = downloadSession else {
            completion(.failure(ManagerErrors.NullSession))
            return
        }
        
       
        let customOperation = NetworkDownloadOperation(url: url, session: downloaddSession)

        
        //Completion block, execute after operation main() done
        customOperation.completionBlock = {
            
            [weak customOperation, weak self] in
            guard let customOperation = customOperation else {
                return
            }
            
            if customOperation.isCancelled {
                
                completion(.failure(ManagerErrors.OperationCancel))
                return
            }
            
            guard let response = customOperation.response else {
                
                completion(.failure(ManagerErrors.BadData))
                return
                
            }
        
            //Store image data to cache
            if let data = response._data {

                
                self?.imageCache.addImage(imgData: data, url: url)
               
                DispatchQueue.main.async {
                    
                    completion(.success(UIImage(data: data) ?? nil))
                    
                }
                
                
            }

        }
        
        if customOperation.isCancelled {
            return
        }
        
        operationQueue.addOperation(customOperation)
        
    }

}

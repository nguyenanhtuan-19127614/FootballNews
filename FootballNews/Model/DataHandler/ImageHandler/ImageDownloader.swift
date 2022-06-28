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
    
    var data: Data?
    
    var url: String?
    var session: URLSession = URLSession()
    
    private var task : URLSessionDataTask?
    
    init(url: String, session: URLSession) {
       
        super.init()
        self.url = url
        self.session = session

    }
    
    //MARK: Create and run download task
    func runDownloadTask(url: String,
                         session: URLSession,
                         completion: @escaping (Result<Data, Error>) -> Void){
        
        //Create URL
        guard let url = URL(string: url) else {
          
            completion(.failure(ManagerErrors.BadURL))
           
            return
            
        }
        
        self.task = session.dataTask(with: url) {
            

            (data, response, error) in
                                         
          
            guard response != nil else {
                
                completion(.failure(ManagerErrors.BadResponse))
            
                return
                
                
            }
        
            guard let data = data else {

                if let error = error {
                    
                    completion(.failure(error))

                }
        
                return
                
            }
        
            completion(.success(data))
           
        }
        
        self.task?.resume()
       
    }
    
   //MARK: Main function
    
    override func main() {
        
        if isCancelled {
        
            return
            
        }
        
        guard let url = self.url else {
            return
        }
        
        runDownloadTask(url: url, session: self.session) {
            
            [weak self]
            result in
            
            switch result {
                
            case.success(let data):
                
                self?.data = data
                
                
            case.failure(let err):
                print(err)
                self?.data = nil
            }
            
            self?.finish()
            
        }

    }
    
    //Handling cancel, if operation is cancel, cancel download task
    override func cancel() {
        
        super.cancel()
        self.task?.cancel()
        self.finish()
        
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
    
    
    //MARK: Main function, use this for download
    func download (url: String,
                   completion: @escaping ( Result<UIImage?,Error> ) -> Void ){

        //Check if image is in cache
        if let imageCache = imageCache.getImageData(url: url) {
        
            print("Image is already in cache")
            completion(.success(imageCache))
            return
            
        }
        
        guard let downloadSession = downloadSession else {
            completion(.failure(ManagerErrors.NullSession))
            return
        }
        
       
        let customOperation = NetworkDownloadOperation(url: url, session: downloadSession)
        
        //Name custom operation
        customOperation.name = url

        //check if operation allready in queue
//        for ope in operationQueue.operations {
//
//            if customOperation.name == ope.name {
//
//                print("Download Operation already added")
//                customOperation.cancel()
//                completion(.failure(ManagerErrors.DuplicateOperation))
//                return
//
//            }
//
//        }
        
        //Completion block, execute after operation main() done
        customOperation.completionBlock = {
            
            [weak customOperation, weak self] in
            guard let customOperation = customOperation else {
                return
            }
            
            guard let data = customOperation.data else {
                
                completion(.failure(ManagerErrors.BadData))
                return
                
            }
            
            //Store image data to cache
            
            self?.imageCache.addImage(imgData: data, url: url)
            completion(.success(UIImage(data: data) ?? nil))
        
        }
        
      
        //add operation
        operationQueue.addOperation(customOperation)
       
    }

}

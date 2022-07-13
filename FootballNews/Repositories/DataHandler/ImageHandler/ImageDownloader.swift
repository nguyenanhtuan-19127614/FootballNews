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
fileprivate class NetworkDownloadOperation: CustomOperation {

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
            
            completion(.failure(AppErrors.BadURL))
            
            return
            
        }
       
        self.task = session.dataTask(with: url) {
            
            
            (data, response, error) in
            
            guard response != nil else {
                
                completion(.failure(AppErrors.BadResponse))
                
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
        if isExecuting {
            
            self.task?.cancel()
            self.finish()
        }
       
    }
 
}

//MARK: Class Image Downloader
class ImageDownloader {
    
    var offlineMode: Bool = false
    //Singleton
    static let sharedService = ImageDownloader()
    
    //Image Cache
    private let imageCacheLRU: LRUCache
    
    //Disk Cache
    private let diskCache = DiskCache()
    
    //Constant (Use to config sessoin)
    private let timeoutForRequest = TimeInterval(30)
    private let timeoutForResource = TimeInterval(60)
    
    private let sessionConfig = URLSessionConfiguration.default
    
    private var downloadSession: URLSession?
    
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
        
        //Create Cache, if online mode, use diskcache to store local
        imageCacheLRU = LRUCache(size: 20)
        
    }
    
    //MARK: Main function, use this for download
    func download (url: String,
                   completion: @escaping ( Result<UIImage?,Error> ) -> Void ){
        
       
        //Check if offline mode
        if offlineMode == true {
            
            guard let image = diskCache.loadImageFromDisk(imageName: url) else {
                completion(.failure(AppErrors.BadData))
                return
            }
            completion(.success(image))
            return
            
        }
        
        guard let downloadSession = downloadSession else {
            
            completion(.failure(AppErrors.NullSession))
            return
            
        }
        
        
        let customOperation = NetworkDownloadOperation(url: url, session: downloadSession)
        
        //Name custom operation
        customOperation.name = url
        
        //check if operation allready in queue
        for ope in operationQueue.operations.reversed() {
            
            if customOperation.name == ope.name {
                
                //Cancel operation and get result from operation that already in queue
                customOperation.cancel()
                
                //Create a operation waiting for executing operaion
                let waitingOperation = BlockOperation {
                    
                    guard let data = (ope as! NetworkDownloadOperation).data else {
                        
                        completion(.failure(AppErrors.BadData))
                        return
                        
                    }
                    
                    guard let image = UIImage(data: data) else {
                        
                        completion(.failure(AppErrors.BadData))
                        return
                        
                    }
        
                    completion(.success(image))
                    
                }
                
                waitingOperation.addDependency(ope)
            
                operationQueue.addOperation(waitingOperation)
                
                return
               
            }
            
        }
        
        //Check if image is in cache
        if let cachedImage = imageCacheLRU.getValue(key: url) {
    
            completion(.success(cachedImage))
            return
            
        }
        
        //Completion block, execute after operation main() done
        customOperation.completionBlock = {
            
            [weak customOperation, weak self] in
            
            guard let customOperation = customOperation,
                  let self = self else {
                
                completion(.failure(AppErrors.DuplicateOperation))
                return
                
            }
            
            guard let data = customOperation.data else {
                
                completion(.failure(AppErrors.BadData))
                return
                
            }
            
            //Store image data to cache
            
            guard let image = UIImage(data: data) else {
                
                completion(.failure(AppErrors.BadData))
                return
                
            }
            //save cache
            self.imageCacheLRU.addValue(value: image, key: url)
            
            completion(.success(image))
            
            
        }
        
        
        //add operation
        operationQueue.addOperation(customOperation)
        
    }
    
}

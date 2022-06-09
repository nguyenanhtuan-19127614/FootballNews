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
        
            try self.downloader.networkManager.callApi(self.url, .GET, nil)
            
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
        
        //Create Observer Function
        createObservers()
        
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
    func download(url: String,
             method: HttpMethod = .GET,
             queryItems: [String: String]? = nil) {
        
        let customOperation = NetworkDownloadOperation(self)
        customOperation.setupOperation(url: url)
        operationQueue.addOperation(customOperation)
        
    }
    
    //startCallApi
    func startCallApi(_ url: String,
                      _ method: HttpMethod,
                      _ queryItems: [String : String]?,
                      session: URLSession) throws {
        
        guard let urlComponent = URLComponents(string: url) else {
            throw(ManagerErrors.BadURL)
        }
        
        //Create URL
        let url = urlComponent.url!
        
        //Create Download Task
        let downloadTask = session.dataTask(with: url) {
            
            (data, response, error) in
            
            if let error = error {
        
                print(error.localizedDescription)
        
            }
    
            guard let response = response else {
                
                return
                
            }
        
            guard let data = data else {
                
                return
                
            }
            
            let responseBody = Response(_data: data, _response: response, _error: error)
            let userInfo = ["responseBody": responseBody]
            let notificationName = NSNotification.Name("download1")
            
            // Post noti
            NotificationCenter.default.post(
                name: notificationName,
                object: nil,
                userInfo: userInfo)
            
        }
        
        downloadTask.resume()
    }
    
    //MARK: Create Observers to get noti
    func createObservers() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dosomething(_:)),
            name: NSNotification.Name ("download1"),
            object: nil)
        
    }
    
    //MARK: Observers Function
    @objc func dosomething(_ notification: Notification) {
        
        try? checkResponse(response: notification.userInfo?["responseBody"] as! Response)
        
        if let data = (notification.userInfo?["responseBody"] as! Response )._data {
            
            let imgData: Data = data as! Data
            if let img = UIImage(data: imgData) {
                
                print(img.description)
                
            }
           
        }

    }
    
}



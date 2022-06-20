//
//  UIImageViewExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 16/06/2022.
//

import Foundation
import UIKit



extension UIImageView {
    
    
    func loadImage( url: String?)  {
        
        guard let url = url else {
            return
        }
            
//        ImageDownloader.sharedService.download(url: url) {
//
//            [weak self]
//            result in
//            switch result {
//
//            case .success(let data):
//
//                DispatchQueue.main.async() {
//
//                    self?.image = UIImage(data: data)
//
//                }
//
//
//            case .failure(let err):
//
//                DispatchQueue.main.async {
//                    self?.image = UIImage(named: "loading")
//                }
//                print(err)
//            }
//            gr.leave()
//        }
        let lock = NSLock()
        if let imageCache = ImageCache.shared.getImageData(url: url) {

            print("Image is already in cache")
            
            DispatchQueue.main.async {
                
                lock.lock()
                self.image = UIImage(data: imageCache)
                lock.unlock()
                
            }
           
            return

        }

        let dispatchQueue = DispatchQueue(label: "loadImageQueue", qos: .utility, attributes: .concurrent)
        let operationQueue = OperationQueue() 
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.underlyingQueue = dispatchQueue

        guard let downloadSession = ImageDownloader.sharedService.downloadSession else {
            return
        }
        
        let customOperation = NetworkDownloadOperation(url: url, session: downloadSession )
        customOperation.completionBlock = {
            
            if customOperation.isCancelled {
                
                DispatchQueue.main.async {
                    
                    self.image = UIImage(named: "loading")
                    
                }
                return

            }

            guard let response = customOperation.response else {

                return

            }

            //Store image data to cache
            if let data = response._data {

                DispatchQueue.main.async() {
                    
                    lock.lock()
                    ImageCache.shared.addImage(imgData: data, url: url)
                    self.image = UIImage(data: data)
                    lock.unlock()

                }

            }

        }

        operationQueue.addOperation(customOperation)
    }
}

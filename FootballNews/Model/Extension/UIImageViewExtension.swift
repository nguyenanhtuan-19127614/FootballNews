//
//  UIImageViewExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 16/06/2022.
//

import Foundation
import UIKit

fileprivate class LoadImageOperation: CustomOperation {
    
    var imgData: Data?

    override func main() {
        
        print(self.url)
        if isCancelled {
            
            return
            
        }
     
        ImageDownloader.sharedService.download(url: self.url) { [weak self] result in
            
            switch result {
           
            case .success(let data):
                
                self?.imgData = data
                self?.finish()
                
                                
            case .failure(let err):
                print(err)
                
            }
        }
        
    }
}

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
//                DispatchQueue.main.async {
//
//                    self?.image = UIImage(data: data)
//
//                }
//
//            case .failure(let err):
//
//                DispatchQueue.main.async {
//                    self?.image = UIImage(named: "loading")
//                }
//                print(err)
//            }
//        }
        
//        let operation = LoadImageOperation(url: url)
//
//        operation.completionBlock = {
//            print("haha")
//            if let imgdata = operation.imgData {
//                print(imgdata)
//                DispatchQueue.main.async {
//
//                    self.image = UIImage(data: imgdata)
//
//                }
//            }
//        }
//        ImageDownloader.sharedService.operationQueue.addOperation(operation)
        if let imageCache = ImageCache.shared.getImageData(url: url) {
            
            print("Image is already in cache")
            self.image = UIImage(data: imageCache)
            return
            
        }
        
        let dispatchQueue = DispatchQueue(label: "loadImageQueue", qos: .userInitiated, attributes: .concurrent)
        let operationQueue = OperationQueue()
        operationQueue.underlyingQueue = dispatchQueue

        guard let downloadSession = ImageDownloader.sharedService.downloadSession else {
            return
        }
        let customOperation = NetworkDownloadOperation(url: url, session: downloadSession )
        customOperation.completionBlock = {
            
            if customOperation.isCancelled {

                return

            }
            
            guard let response = customOperation.response else {

                return

            }

            //Store image data to cache
            if let data = response._data {

                DispatchQueue.main.async {

                    ImageCache.shared.addImage(imgData: data, url: url)
                    self.image = UIImage(data: data)

                }

            }

        }

        operationQueue.addOperation(customOperation)
             
        
    }
}

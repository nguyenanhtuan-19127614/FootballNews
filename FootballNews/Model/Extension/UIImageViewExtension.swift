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
    
    
    func loadImage(url: String?) {
        
        guard let url = url else {
            return
        }
        
//        let operationQueue = OperationQueue()
//        let customOperation = LoadImageOperation(url: url)
//        customOperation.completionBlock = {
//
//            if let imgData = customOperation.imgData {
//
//                DispatchQueue.main.async {
//
//                    self.image = UIImage(data: imgData)
//
//                }
//
//            }
//
//        }
//
//        operationQueue.addOperation(customOperation)
        
        let gr = DispatchGroup()
        gr.enter()
        ImageDownloader.sharedService.download(url: url) { [weak self] result in

            //print("dsadasdasdas")
            switch result {

            case .success(let data):

                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }

            case .failure(let err):
                print(err)

            }
            gr.leave()
        }

        gr.wait()
        
    }
}

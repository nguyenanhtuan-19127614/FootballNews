//
//  UIImageViewExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 16/06/2022.
//

import Foundation
import UIKit

extension UIImageView {
    
    
    func loadImage(url: String) {
        var tempData = Data()
        let gr = DispatchGroup()
        gr.enter()
        ImageDownloader.sharedService.download(url: url) { [weak self] result in
            
            //print("dsadasdasdas")
            switch result {
           
            case .success(let data):
                
                tempData = data
                DispatchQueue.main.async {
                    self?.image = UIImage(data: tempData)
                }
                
            case .failure(let err):
                print(err)
                
            }
            gr.leave()
        }
        
        gr.wait()
        
//        gr.enter()
//        ImageDownloader.sharedService.download(url: url) { [weak self] result in
//
//            switch result {
//
//            case .success(let data):
//
//                tempData = data
//                DispatchQueue.main.async {
//                    self?.image = UIImage(data: tempData)
//                }
//
//            case .failure(let err):
//                print(err)
//            }
//
//            gr.leave()
//        }
//        gr.wait()
        
       

    }
}

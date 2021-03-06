//
//  UIImageViewExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 16/06/2022.
//

import Foundation
import UIKit

extension UIImageView {
    
    //Load Image from URL
    func loadImageFromUrl(url: String?)  {
        
        self.image = nil
        
        guard let url = url else {
            return
        }
        
        ImageDownloader.sharedService.download(url: url) {

            [weak self]
            result in
            switch result {

            case .success(let image):

                DispatchQueue.main.async() {

                    self?.image = image

                }


            case .failure(let err):

                if(err as! AppErrors != AppErrors.DuplicateOperation) {
                    
                    DispatchQueue.main.async {
                        
                        self?.image = UIImage(named: "noImage")
                        
                    }
                    
                }
   
                print(err)
            }
  
        }

    }
    
    func stopLoadImagefromURL(url: String?) {
        
        guard let url = url else {
            return
        }
      
        for ope in ImageDownloader.sharedService.operationQueue.operations.reversed() {
            
            if ope.name == url {
                ope.cancel()
                return
            }
            
        }
     
    }
   
}

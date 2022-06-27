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
        
        ImageDownloader.sharedService.download(url: url) {

            [weak self]
            result in
            switch result {

            case .success(let image):

                DispatchQueue.main.async() {

                    self?.image = image

                }


            case .failure(let err):

                DispatchQueue.main.async {
                    self?.image = UIImage(named: "loading")
                }
                print(err)
            }
  
        }

    }
}

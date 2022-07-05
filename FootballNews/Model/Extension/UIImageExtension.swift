//
//  UIImageExtension.swift
//  FootballNews
//
//  Created by LAP13606 on 04/07/2022.
//

import UIKit

extension UIImage {
    
    func createGradientImage(colors: [CGColor], frame: CGRect) -> UIImage? {
        
        let gradient = CAGradientLayer()
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        var updatedFrame = frame
        updatedFrame.size.height += frame.origin.y
        
        gradient.frame = updatedFrame
        gradient.colors = colors;
        
        //Render Gradient Image
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return image
    }
    
    func documentDirectoryPath(imageName: String) -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    func saveImageToDisk(_ imageName: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print("name \(imageName)")
        if let jpgData = self.jpegData(compressionQuality: 0.5) {
            
            
            let path = documentsDirectory.appendingPathComponent(URL(string: imageName)?.lastPathComponent ?? "")
            print("path: \(path)")
            do {
                
                try jpgData.write(to: path)
                
            } catch let err {
                
                print(err)
                
            }
            
        }
    }
    
    func loadImageFromDisk(imageName: String) -> UIImage? {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        let filePathName = URL(string: imageName)?.lastPathComponent ?? ""
        let imageUrl = documentsDirectory.appendingPathComponent(filePathName)
        
        do {
            
            let imageData = try Data(contentsOf: imageUrl)
            return UIImage(data: imageData)
            
        } catch {
            print("Error loading image : \(error)")
            return nil
        }

    }
    
    func removeImageFromDisk(fileName: String) {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        let filePathName = URL(string: fileName)?.lastPathComponent ?? ""
        let fileURL = documentsDirectory.appendingPathComponent(filePathName)
        
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
            
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }
    }
    
}

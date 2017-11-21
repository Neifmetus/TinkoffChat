//
//  PicturesModel.swift
//  TinkoffChat
//
//  Created by e.bateeva on 20.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import UIKit

class PicturesViewModel {
    
    var imageLoadService: ImageLoadService?
    
    init() {
        self.imageLoadService = ImageLoadService()
    }
    
    func getImageUrls(result: @escaping ([String]) -> Void){
        
        imageLoadService?.loadImages { (pictures, error) in
            if let error = error {
                print("Error has appeared in loading \(error)")
                result([])
            }
            
            var imageUrls: [String] = []
            if let pictures = pictures {
                for pic in pictures {
                    imageUrls.append(pic.imageUrl)
                }
            }
            
            result(imageUrls)
        }
    }
    
    private func getImages(pictures: [Picture]?) -> [UIImage] {
        
        var images: [UIImage] = []
        if let pictures = pictures {
            for object in pictures {
                
                do {
                    if let url = URL(string: object.imageUrl) {
                        let data = try Data(contentsOf: url) 
                        if let image = UIImage(data: data) {
                            images.append(image)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        return images
    }
}

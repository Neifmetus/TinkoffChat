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
    
    func getImage(result: @escaping ([UIImage]) -> Void){
        
        imageLoadService?.loadImages { (pictures, error) in
            if let error = error {
                print("Error has appeared in loading \(error)")
                result([])
            }
            
            let images = self.getImages(pictures: pictures)
            result(images)
        }
    }
    
    private func getImages(pictures: [Picture]?) -> [UIImage] {
        
        var images: [UIImage] = []
        if let pictures = pictures {
            for object in pictures {
                
                let url = URL(string: object.imageUrl)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                if let image = UIImage(data: data!) {
                    images.append(image)
                }
                
//                let url = URL(string: object.imageUrl)
//
//                DispatchQueue.global().async {
//                    do {
//                        let data = try Data(contentsOf: url!)
//                        DispatchQueue.main.async {
//                            if let image = UIImage(data: data) {
//                                images.append(image)
//                            }
//                        }
//                    } catch {
//                        print("Error to get image by url \(error)")
//                    }
//                }
            }
        }
        
        return images
    }
}

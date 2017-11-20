//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by e.bateeva on 20.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation

struct Picture {
    let imageUrl: String
}

class ImageParser: Parser<[Picture]> {
    
    override func parse(data: Data) -> [Picture]? {
        // parse the result as JSON, since that's what the API provides
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let hits = json["hits"] as? [[String : Any]] else {
                    return nil
            }
            
            var images: [Picture] = []
            
            for appObject in hits {
                guard let imageUrl = appObject["webformatURL"] as? String else { continue }
                images.append(Picture(imageUrl: imageUrl))
            }
            
            return images
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
    }
}

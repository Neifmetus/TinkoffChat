//
//  ImageLoadService.swift
//  TinkoffChat
//
//  Created by e.bateeva on 20.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation

class ImageLoadService {
    
    func loadImages(completionHandler: @escaping ([Picture]?, String?) -> Void) {
        let config = RequestConfig<[Picture]>(request: ImageRequest(), parser: ImageParser())
        RequestSender().send(config: config) { (result: Result<[Picture]>) in
            
            switch result {
            case .Success(let pictures):
                completionHandler(pictures, nil)
            case .Fail(let error):
                completionHandler(nil, error)
            }
        }
    }
}

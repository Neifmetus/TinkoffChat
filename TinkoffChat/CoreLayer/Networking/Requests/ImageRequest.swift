//
//  ImageRequest.swift
//  TinkoffChat
//
//  Created by e.bateeva on 20.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    
    let baseUrl = "https://pixabay.com/api/?key=7109646-680a8f8f8fc419c83436852a2"
    
    var urlRequest: URLRequest? {
        let urlString: String = "\(baseUrl)&image_type=photo&pretty=true&per_page=150"
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
}

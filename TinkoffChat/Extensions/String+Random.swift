//
//  String+Random.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 08.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

extension String {
    
    static func randomWith(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}

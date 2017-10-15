//
//  GCDManager.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 14.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class GCDManager {
    
    func saveData(userInfo: @escaping(String?) -> ()) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            
            sleep(5)
            // Save data in file
            if let path = arc4random_uniform(2) == 0 ? "test.txt" : nil {
                DispatchQueue.main.async {
                    print("Save user's data")
                }
                userInfo(path)
            } else {
                print("error")
                userInfo(nil)
            }
        }
    }
    
    func loadData() -> String {
        return ""
    }
}

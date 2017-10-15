//
//  OperationManager.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 14.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class OperationManager {
    
    func saveData(userInfo: @escaping(String?) -> ()) {
        let queue = OperationQueue()
        queue.name = "com.neifmetus.TinkoffChat.dataSaving"
        
        let recordData = {
            // Record data
            sleep(10)
            print("recordData")
            userInfo("test")
        }
        
        queue.addOperation {
            recordData()
        }
    }
    
    func loadData() {
        
    }
}

//
//  OperationManager.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 14.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit
import Foundation

class OperationManager: DataManager {
    
    let coreDataManager = CoreDataManager()
    
    func saveData(profile: [String : Any], userInfo: @escaping(Bool) -> ()) {
        let queue = OperationQueue()
        queue.name = "com.neifmetus.TinkoffChat.dataSaving"
        
        let recordData = {
            
            // Save data in file
            if self.saveToStorage(profile: profile) {
                DispatchQueue.main.async {
                    print("Save user's data")
                }
                
                userInfo(true)
            } else {
                print("error")
                userInfo(false)
            }
        }
        
        queue.addOperation {
            recordData()
        }
    }
    
    func loadData(userInfo: @escaping([String : Any]) -> ()) {
        let queue = OperationQueue()
        queue.name = "com.neifmetus.TinkoffChat.dataLoading"
        
        let loadData = {
            
            if let appUser = CoreDataManager.getAppUser()?.currentUser {
                var profile: [String : Any] = [:]
                profile["Name"] = appUser.name
                profile["Additional_info"] = appUser.additionalInfo
                
                if let image = appUser.image {
                    profile["Profile_image"] = UIImage(data: image)
                }
                
                userInfo(profile)
            } else {
                print("error")
                userInfo([:])
            }
        }
        
        queue.addOperation {
            loadData()
        }
        
    }
    
    private func saveToStorage(profile: [String : Any]) -> Bool {
        
        if let name = profile["Name"], let additionalInfo = profile["Additional_info"], let image = profile["Profile_image"] {
            if let context = CoreDataManager.coreDataStack?.saveContext {
                if let appUser = CoreDataManager.findOrInsertAppUser(in: context)?.currentUser {
                    appUser.name = name as? String
                    appUser.additionalInfo = additionalInfo as? String
                    appUser.image = image as? Data
                    
                    CoreDataManager.coreDataStack?.performSave(context: context, completion: {})
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func retrieveFromJsonFile(fileUrl: URL?) -> [String : Any]? {
        
        // Read data from .json file and transform data into an array
        do {
            if let fileUrl = fileUrl {
                let data = try Data(contentsOf: fileUrl, options: [])
                guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return nil}
                print(personArray)
                return personArray
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}

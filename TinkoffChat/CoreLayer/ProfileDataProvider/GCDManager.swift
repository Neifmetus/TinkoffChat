//
//  GCDManager.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 14.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class GCDManager: DataManager {
    
    func saveData(profile: [String : Any], userInfo: @escaping(URL?) -> ()) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            
            // Save data in file
            if let fileUrl = self.saveToJSONFile(profile: profile) {
                DispatchQueue.main.async {
                    print("Save user's data")
                }
                
                userInfo(fileUrl)
            } else {
                print("error")
                userInfo(nil)
            }
        }
    }
    
    func loadData(userInfo: @escaping([String : Any]) -> ()) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            
            // Load data from file
            if let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileUrl = documentDirectoryUrl.appendingPathComponent("Persons.json")
            
                if let savedInfo = self.retrieveFromJsonFile(fileUrl: fileUrl) {
                    var profile: [String : Any] = [:]
                    if let name = savedInfo["Name"] as? String, let additionalInfo = savedInfo["Additional_info"] as? String, let image = savedInfo["Profile_image"] as? String {
                        profile["Name"] = name
                        profile["Additional_info"] = additionalInfo
                        
                        let dataDecoded : Data = Data(base64Encoded: image, options: .ignoreUnknownCharacters)!
                        let decodedimage = UIImage(data: dataDecoded)
                        profile["Profile_image"] = decodedimage ?? UIImage()
                        
                        userInfo(profile)
                    }
                } else {
                    print("error")
                    userInfo([:])
                }
            }
        }
    }
    
    private func saveToJSONFile(profile: [String : Any]) -> URL? {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Persons.json")
        
        let personArray = profile
        
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: personArray, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
            return nil
        }
    
        return fileUrl
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

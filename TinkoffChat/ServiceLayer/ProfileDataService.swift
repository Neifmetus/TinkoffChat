//
//  ProfileDataService.swift
//  TinkoffChat
//
//  Created by e.bateeva on 31.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class ProfileDataService {
    
    var dataManager: DataManager?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func saveData(name: String, additionalInfo: String, image: UIImage, userInfo: @escaping(Bool) -> ()) {
        var profile: [String : Any] = [:]
        if let jpegData = UIImageJPEGRepresentation(image , 0.5) as NSData? {
            profile = [
                "Name" : name,
                "Additional_info" : additionalInfo,
                "Profile_image" : jpegData
            ]
        }

        dataManager?.saveData(profile: profile) { (success) in
            userInfo(success)
        }
    }
    
    func loadData(userInfo: @escaping(_ name: String, _ additionalInfo: String, _ image: UIImage) -> ()) {
        dataManager?.loadData { (profile) in
            let name = profile["Name"] as? String ?? ""
            let additionalInfo = profile["Additional_info"] as? String ?? ""
            
            var image = UIImage()
            if let profileImage = profile["Profile_image"] {
                if let imageAsData = profileImage as? Data {
                    image = UIImage(data: imageAsData) ?? UIImage()
                }
            }
            
            userInfo(name, additionalInfo, image)
        }
    }
        
}

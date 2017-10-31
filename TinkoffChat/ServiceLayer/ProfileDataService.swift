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
    
    func saveData(name: String, additionalInfo: String, image: UIImage, userInfo: @escaping(URL?) -> ()) {
        var profile: [String : Any] = [:]
        if let jpegData = UIImageJPEGRepresentation(image , 0.5) {
            let encodedString = jpegData.base64EncodedString()
            profile = [
                "Name" : name,
                "Additional_info" : additionalInfo,
                "Profile_image" : encodedString
            ]
        }

        dataManager?.saveData(profile: profile) { (fileUrl) in
            userInfo(fileUrl)
        }
    }
    
    func loadData(userInfo: @escaping(_ name: String, _ additionalInfo: String, _ image: UIImage) -> ()) {
        dataManager?.loadData { (profile) in
            let name = profile["Name"] as? String ?? ""
            let additionalInfo = profile["Additional_info"] as? String ?? ""
            let image = profile["Profile_image"] as? UIImage ?? UIImage()
            userInfo(name, additionalInfo, image)
        }
    }
        
}

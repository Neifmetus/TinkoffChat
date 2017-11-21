//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by e.bateeva on 31.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class ProfileModel {
    
    var dataManager: DataManager
    var service: ProfileDataService
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.service = ProfileDataService(dataManager: dataManager)
    }
    
    func saveData(profileInfo: ProfileInfo, userInfo: @escaping(Bool) -> ()) {
        let name = profileInfo.name
        let additionalInfo = profileInfo.additionalInfo
        let image = profileInfo.image
        
        service.saveData(name: name, additionalInfo: additionalInfo, image: image) { (success) in
            userInfo(success)
        }
    }
    
    func loadData(profileInfo: @escaping(ProfileInfo?) -> ()) {
        service.loadData { name, additionalInfo, image in
            var profile = ProfileInfo()
            profile.name = name
            profile.additionalInfo = additionalInfo
            profile.image = image
            profileInfo(profile)
        }
    }
    
}

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
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func saveData(profileInfo: ProfileInfo, userInfo: @escaping(URL?) -> ()) {
        let service = ProfileDataService(dataManager: dataManager)
        let name = profileInfo.name
        let additionalInfo = profileInfo.additionalInfo
        let image = profileInfo.image
        
        service.saveData(name: name, additionalInfo: additionalInfo, image: image) { (fileUrl) in
            userInfo(fileUrl)
        }
    }
    
}

//
//  CameraHandler.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 01.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class CameraHandler: NSObject {
    
    var delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate
    init(delegate_: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        delegate = delegate_
    }
    
    func getPhotoViaCamera(_ controller: UIViewController, canEdit: Bool) {
        let image = UIImagePickerController()
        image.delegate = delegate
        
        image.sourceType = .camera
        image.allowsEditing = false
        
        controller.present(image, animated: true)
    }
    
    func getPhotoViaLibrary(_ onVC: UIViewController, canEdit: Bool) {
        let image = UIImagePickerController()
        image.delegate = delegate
        
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        
        onVC.present(image, animated: true)
    }
    
    func getPhotoViaWeb(_ onVC: UIViewController, canEdit: Bool) {
        let image = UIImagePickerController()
        
    }
    
}

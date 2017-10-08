//
//  ViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 20.09.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var uploadPhotoView: UIView?
    @IBOutlet weak var photoImageView: UIImageView?
    @IBOutlet weak var editButton: UIButton?
    @IBOutlet weak var uploadImageButton: UIButton?
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImage(_ sender: Any) {
        let camera = CameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in

            camera.getPhotoViaCamera(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoViaLibrary(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }

        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Фрейм не выводится, поскольку фактически инициализация элементов ViewController происходит
        // во viewDidLoad, а init вызывается раньше
        if let editButton = editButton {
            print("Edit button frame in init: \(editButton.frame)")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        photoImageView?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uploadPhotoView = uploadPhotoView else {
            print("Unable to use uploadPhotoView")
            return
        }
        
        uploadPhotoView.contentMode = .scaleAspectFill
        uploadPhotoView.layer.cornerRadius = uploadPhotoView.frame.width / 2
        uploadPhotoView.layer.masksToBounds = true

        guard let photoImageView = photoImageView else {
            print("Unable to use photoImageView")
            return
        }
        
        photoImageView.layer.cornerRadius = uploadPhotoView.layer.cornerRadius
        photoImageView.layer.masksToBounds = true
        
        guard let editButton = editButton else {
            print("Unable to use editButton")
            return
        }
        
        editButton.layer.borderWidth = 2
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.cornerRadius = 10
        editButton.layer.masksToBounds = true
        
        guard let uploadImageButton = uploadImageButton else {
            print("Unable to use uploadImageButton")
            return
        }
        
        let buttonImage = UIImage(named: "slr-camera-2-xxl.png")?.withRenderingMode(.alwaysTemplate)
        uploadImageButton.setImage(buttonImage, for: UIControlState.normal)
        uploadImageButton.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        if let editButton = editButton {
            print("Edit button frame \(editButton.frame)" )
        } else {
            print("Unable to print Edit button's frame")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        
        if let editButton = editButton {
            print("Edit button frame \(editButton.frame)" )
        } else {
            print("Unable to print Edit button's frame")
            
            // Разница во фрейма связана с тем, что autolayout'у требуется время для калькулирования фреймов
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
}


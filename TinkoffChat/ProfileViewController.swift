//
//  ViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 20.09.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

struct UserInfo {
    var name: String = "Name Surname"
    var additionalInfo: String = "Chat participant"
    var image: UIImage? = UIImage(named: "placeholder-user")
}

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var uploadPhotoView: UIView?
    @IBOutlet weak var photoImageView: UIImageView?
    @IBOutlet weak var uploadImageButton: UIButton?
    @IBOutlet weak var additionalInfoLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    static var userInfo = UserInfo()
    
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
        
        guard let gcdButton = gcdButton else {
            print("Unable to use gcdButton")
            return
        }
        
        setButtonStyle(button: gcdButton)
        
        guard let operationButton = operationButton else {
            print("Unable to use gcdButton")
            return
        }
        
        setButtonStyle(button: operationButton)
        
        guard let uploadImageButton = uploadImageButton else {
            print("Unable to use uploadImageButton")
            return
        }
        
        activityIndicatorView.isHidden = true
        activityIndicatorView.hidesWhenStopped = true
        
        let buttonImage = UIImage(named: "slr-camera-2-xxl.png")?.withRenderingMode(.alwaysTemplate)
        uploadImageButton.setImage(buttonImage, for: UIControlState.normal)
        uploadImageButton.tintColor = UIColor.white
        
        //load user Info
        ProfileViewController.userInfo.name = ""
        ProfileViewController.userInfo.additionalInfo = ""
        ProfileViewController.userInfo.image = UIImage()
    }

    @IBAction func saveWithGCD(_ sender: Any) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        
        let dataManager = GCDManager()
        
        dataManager.saveData { (info) in
            print(info)
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.gcdButton.isEnabled = true
                self.operationButton.isEnabled = true
                
                if info != nil {
                    self.showSuccessAlert()
                } else {
                    self.showErrorAlert(function: {
                        self.saveWithGCD(sender)
                    })
                }
            }
        }
    }
    
    @IBAction func saveWithOperation(_ sender: Any) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        
        let operationManager = OperationManager()
        
        operationManager.saveData { (info) in
            print(info)
            OperationQueue.main.addOperation {
                self.activityIndicatorView.stopAnimating()
                self.gcdButton.isEnabled = true
                self.operationButton.isEnabled = true
                
                if info != nil {
                    self.showSuccessAlert()
                } else {
                    self.showErrorAlert(function: {
                        self.saveWithOperation(sender)
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
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
    
    private func setButtonStyle(button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Данные успешно прогружены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert(function: @escaping () -> ()) {
        let alert = UIAlertController(title: "Данные успешно прогружены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        let repeatAction = UIAlertAction(title: "Повторить", style: .default, handler: {
            (alert: UIAlertAction!) in function()
        })
        
        alert.addAction(repeatAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateUserInfo() -> Bool {
        let user = ProfileViewController.userInfo
        
        var changed = user.name == nameLabel?.text
        changed = user.additionalInfo == additionalInfoLabel?.text
        changed = user.image = photoImageView?.image
        
        user.name = nameLabel?.text
        user.additionalInfo = additionalInfoLabel?.text
        user.image = photoImageView?.image
        
        return changed
    }
}


//protocol DataManager {
//    func saveData((String, String) -> ())
//
//    func loadData() -> String
//}


//
//  ViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 20.09.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

struct ProfileInfo {
    var name: String = "Name"
    var additionalInfo: String = "Chat participant"
    var image: UIImage = UIImage(named: "placeholder-user.jpg") ?? UIImage()
}

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PicturesViewControllerDelegate {
    
    @IBOutlet weak var uploadPhotoView: UIView?
    @IBOutlet weak var photoImageView: UIImageView?
    @IBOutlet weak var uploadImageButton: UIButton?
    @IBOutlet weak var additionalInfoTextEdit: UITextField!
    @IBOutlet weak var nameTextEdit: UITextField!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let dataManager: DataManager = GCDManager()
    var model: ProfileModel?
    var profileInfo = ProfileInfo()
    
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
        let loadPhoto = UIAlertAction(title: "Load Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoViaWeb(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }

        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(loadPhoto)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        photoImageView?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateProfileImage(image: UIImage) {
        photoImageView?.image = image
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
        self.model = ProfileModel(dataManager: self.dataManager)
        model?.loadData { (userInfo) in
            DispatchQueue.main.async {
                if let profile = userInfo {
                    self.profileInfo = profile
                    self.nameTextEdit?.text = profile.name
                    self.additionalInfoTextEdit?.text = profile.additionalInfo
                    
                    if profile.image == UIImage() {
                        self.photoImageView?.image = UIImage(named: "placeholder-user.jpg") ?? UIImage()
                    } else {
                        self.photoImageView?.image = profile.image
                    }
                }
            }
        }
        
        // handle keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }

    @IBAction func saveWithGCD(_ sender: Any) {
        nameTextEdit.endEditing(true)
        additionalInfoTextEdit.endEditing(true)
        
        if updateUserInfo() {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            gcdButton.isEnabled = false
            operationButton.isEnabled = false
            
            let dataManager: DataManager = GCDManager()
            let model = ProfileModel(dataManager: dataManager)
            model.saveData(profileInfo: profileInfo) { (success) in
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.gcdButton.isEnabled = true
                    self.operationButton.isEnabled = true

                    if success {
                        self.showSuccessAlert()
                    } else {
                        self.showErrorAlert(function: {
                            self.saveWithGCD(sender)
                        })
                    }
                }
            }

        }
    }
    
    @IBAction func saveWithOperation(_ sender: Any) {
        nameTextEdit.endEditing(true)
        additionalInfoTextEdit.endEditing(true)
        
        if updateUserInfo() {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            gcdButton.isEnabled = false
            operationButton.isEnabled = false
            
            let dataManager: DataManager = OperationManager()
            let model = ProfileModel(dataManager: dataManager)
            model.saveData(profileInfo: profileInfo) { (success) in
                OperationQueue.main.addOperation {
                    self.activityIndicatorView.stopAnimating()
                    self.gcdButton.isEnabled = true
                    self.operationButton.isEnabled = true
                    
                    if success {
                        self.showSuccessAlert()
                    } else {
                        self.showErrorAlert(function: {
                            self.saveWithGCD(sender)
                        })
                    }
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
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert(function: @escaping () -> ()) {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        let repeatAction = UIAlertAction(title: "Повторить", style: .default, handler: {
            (alert: UIAlertAction!) in function()
        })
        
        alert.addAction(repeatAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateUserInfo() -> Bool {
        let user = profileInfo
        
        let changed = (user.name == nameTextEdit?.text
            && user.additionalInfo == additionalInfoTextEdit?.text
            && user.image == photoImageView?.image)
        
        if let name = nameTextEdit?.text {
            profileInfo.name = name
        }
        
        if let additionalInfo = additionalInfoTextEdit?.text {
            profileInfo.additionalInfo = additionalInfo
        }
        
        if let image = photoImageView?.image {
            profileInfo.image = image
        }
        
        return !changed
    }
    
    @objc private func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let isShowing = notification.name == .UIKeyboardWillShow
            
            self.view.frame.origin.y = isShowing ? -keyboardFrame.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}

protocol DataManager {
    func saveData(profile: [String : Any], userInfo: @escaping(Bool) -> ())

    func loadData(userInfo: @escaping([String : Any]) -> ())
}


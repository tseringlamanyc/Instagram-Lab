//
//  ProfileVC.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import LGButton
import FirebaseAuth
import Kingfisher

class ProfileVC: UIViewController {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
    }()
    
    private let storageService = StorageServices()
    
    private var selectedImage: UIImage? {
        didSet {
            userPic.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPic.isUserInteractionEnabled = true
        userPic.addGestureRecognizer(longPressGesture)
        userNameTF.delegate = self
        updateUI()
    }
    
    private func updateUI() {
       guard let user = Auth.auth().currentUser else {
            return
        }
        userName.text = user.displayName
        userPic.kf.setImage(with: user.photoURL)
    }
    
    @objc
    private func showPhotoOptions() {
        let alertController = UIAlertController(title: "Choose option", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        
        let photoLibrary = UIAlertAction(title: "Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction func updateProfile(_ sender: LGButton) {
        
        guard let displayName = userNameTF.text, !displayName.isEmpty, let selectedImage = selectedImage else {
            showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Missing Fields")
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let resizeImage = UIImage.resizeImage(originalImage: selectedImage, rect: userPic.bounds)
        
        storageService.uploadPhoto(userId: user.uid, image: resizeImage) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Error upload:\(error.localizedDescription)")
                }
            case .success(let url):
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                
                request?.displayName = displayName
                
                request?.photoURL = url
                
                request?.commitChanges(completion: { [unowned self] (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Couldnt commit changes:\(error.localizedDescription)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showStatusAlert(withImage: UIImage(systemName: "star.fill"), title: "Success", message: "Changes made")
                        }
                    }
                })
            }
        }
    }
    
    
    @IBAction func signOutPressed(_ sender: LGButton) {
        do {
            try Auth.auth().signOut()
            UIViewController.showVC(storyboard: "Login", VCid: "LoginVC")
        } catch {
            DispatchQueue.main.async {
                self.showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Couldnt sign out")
            }
        }
    }
}

extension ProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError()
        }
        selectedImage = image
        dismiss(animated: true)
    }
}

//
//  UploadVC.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import Lottie
import LGButton
import FirebaseAuth
import FirebaseFirestore

class UploadVC: UIViewController {
    
    @IBOutlet weak var cameraView: AnimationView!
    @IBOutlet weak var libraryView: AnimationView!
    @IBOutlet weak var uploadPhoto: UIImageView!
    @IBOutlet weak var captionTF: UITextField!
    @IBOutlet weak var location: UILabel!
    
    
    
    private var locationVC: LocationVC = {
      let storyboard = UIStoryboard(name: "Location", bundle: nil)
        let locationVC = storyboard.instantiateViewController(identifier: "Location") as! LocationVC
        return locationVC
    }()
    
    private lazy var searchController: UISearchController = {
      let sc = UISearchController(searchResultsController: locationVC)
      sc.searchResultsUpdater = locationVC
      sc.hidesNavigationBarDuringPresentation = false
      sc.searchBar.placeholder = "Picture Location"
      sc.dimsBackgroundDuringPresentation = false
      sc.obscuresBackgroundDuringPresentation = false
      definesPresentationContext = true
      sc.searchBar.autocapitalizationType = .none
      return sc
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private let dbService = DatabaseServices()
    
    private let storageService = StorageServices()
    
    private var selectedImage: UIImage? {
        didSet {
            uploadPhoto.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLottie()
        startLottie2()
        captionTF.delegate = self
        navigationItem.searchController = searchController
        locationVC.delegate = self
        navigationItem.title = "Choose a source"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        startLottie2()
        startLottie()
    }
    
    private func startLottie() {
        let animation1 = Animation.named("camera")
        cameraView.animation = animation1
        cameraView.loopMode = .loop
        cameraView.play()
    }
    
    private func startLottie2() {
        let animation2 = Animation.named("photolib")
        libraryView.animation = animation2
        libraryView.loopMode = .loop
        libraryView.play()
    }
    
    
    @IBAction func cameraPicked(_ sender: LGButton) {
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true)
    }
    
    
    @IBAction func libraryPicked(_ sender: LGButton) {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true)
    }
    
    
    @IBAction func postPressed(_ sender: UIButton) {
        guard let caption = captionTF.text, !caption.isEmpty, let selectedImage = selectedImage, let location = location.text, !location.isEmpty else {
            showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Missing Fields")
            return
        }
        
        guard let displayName = Auth.auth().currentUser?.displayName else {
            showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Profile Incomplete")
            return
        }
        
        let resizeImage = UIImage.resizeImage(originalImage: selectedImage, rect: uploadPhoto.bounds)
        
        dbService.createPhoto(userName: displayName, photoCaption: caption, location: location) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Couldnt create:\(error.localizedDescription)")
                }
            case .success(let documentId):
                DispatchQueue.main.async {
                    self?.showStatusAlert(withImage: UIImage(systemName: "star.fill"), title: "Success", message: "Photo posted")
                }
                self?.uploadPhoto(image: resizeImage, documentId: documentId)
                self?.uploadPhoto.image = nil
                self?.captionTF.text = ""
            }
        }
        
    }
    
    private func uploadPhoto(image: UIImage, documentId: String) {
        storageService.uploadPhoto(photoId: documentId, image: image) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Upload fail:\(error.localizedDescription)")
                }
            case .success(let url):
                self?.updatePhotoURL(url: url, documentId: documentId)
            }
        }
    }
    
    private func updatePhotoURL(url: URL, documentId: String) {
        
        Firestore.firestore().collection(DatabaseServices.userPhotos).document(documentId).updateData(["photoURL" : url.absoluteString]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Update fail: \(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    

}

extension UploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError()
        }
        selectedImage = image
        dismiss(animated: true)
    }
}

extension UploadVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UploadVC: LocationVCDelegate {
    func didSelect(location: String, VC: LocationVC) {
        self.location.text = location
    }
    
    
    func didScroll(VC: LocationVC) {
        searchController.searchBar.resignFirstResponder()
    }
}

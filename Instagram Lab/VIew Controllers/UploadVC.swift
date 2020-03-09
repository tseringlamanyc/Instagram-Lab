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

class UploadVC: UIViewController {
    
    @IBOutlet weak var cameraView: AnimationView!
    @IBOutlet weak var libraryView: AnimationView!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLottie()
        startLottie2()
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
        
    }
    
    
    @IBAction func libraryPicked(_ sender: LGButton) {
        
    }
    
}

extension UploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError()
        }
        dismiss(animated: true)
    }
}

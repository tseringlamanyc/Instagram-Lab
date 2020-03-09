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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLottie()
        startLottie2()
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

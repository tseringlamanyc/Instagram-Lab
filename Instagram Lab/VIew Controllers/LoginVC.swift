//
//  LoginVC.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import Lottie
import LGButton

class LoginVC: UIViewController {
    
    @IBOutlet weak var login: AnimationView!
    
    override func viewDidLoad() {
        startLottie()
    }

    private func startLottie() {
        let animation = Animation.named("camera")
        login.animation = animation
        login.loopMode = .loop
        login.play()
    }
    
    
}

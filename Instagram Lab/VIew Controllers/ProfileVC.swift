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

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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

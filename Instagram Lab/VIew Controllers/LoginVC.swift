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

enum AccountState {
    case existingUser
    case newUser
}

class LoginVC: UIViewController {
    
    @IBOutlet weak var login: AnimationView!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var authSession = AuthenticationSession()
    
    private var accountState: AccountState = .existingUser
    
    override func viewDidLoad() {
        startLottie()
        passTF.delegate = self
        emailTF.delegate = self
    }
    
    private func startLottie() {
        let animation = Animation.named("camera")
        login.animation = animation
        login.loopMode = .loop
        login.play()
    }
    
    
    @IBAction func loginPressed(_ sender: LGButton) {
        
        sender.isLoading = true
        guard let email = emailTF.text, !email.isEmpty, let password = passTF.text, !password.isEmpty else {
            showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Please fill all fields")
            sender.isLoading = false
            return
        }
        
        authSession.signExistingUser(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorLabel.text = "Error: \(error.localizedDescription)"
                    self?.errorLabel.textColor = .systemRed
                }
            case .success(_):
                DispatchQueue.main.async {
                    self?.navigateToMainView()
                }
            }
        }
    }
    
    
    @IBAction func signupPressed(_ sender: LGButton) {
        guard let email = emailTF.text, !email.isEmpty, let password = passTF.text, !password.isEmpty else {
            showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Fail", message: "Please fill all fields")
            return
        }
        
        authSession.createNewUser(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorLabel.text = "Error: \(error.localizedDescription)"
                    self?.errorLabel.textColor = .systemRed
                }
            case .success(_):
                DispatchQueue.main.async {
                    self?.showStatusAlert(withImage: UIImage(systemName: "star.fill"), title: "Success", message: "Account Created")
                }
            }
        }
    }
    
    private func navigateToMainView() {
        UIViewController.showVC(storyboard: "Main", VCid: "MainTab")
    }
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

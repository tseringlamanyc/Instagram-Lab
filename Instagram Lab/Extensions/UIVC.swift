//
//  UIVC.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public static func resetWindow (rootVC: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first, let sceneDelegate = scene.delegate as? SceneDelegate, let window = sceneDelegate.window else {
            fatalError("couldnt set window")
        }
        window.rootViewController = rootVC
    }
    
    public static func showVC(storyboard: String, VCid: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: VCid)
        resetWindow(rootVC: newVC)
    }
}

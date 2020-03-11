//
//  FeedCell.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth

class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var photoCaption: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    public func updateCell(insta: InstaModel) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        userName.text = insta.userName
        photoCaption.text = insta.photoCaption
        profilePhoto.kf.setImage(with: user.photoURL)
        userPhoto.kf.setImage(with: URL(string: insta.photoURL))
        locationLabel.text = insta.location
    }
}

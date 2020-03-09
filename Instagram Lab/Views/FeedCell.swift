//
//  FeedCell.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePhoto: DesignableImageView!
    @IBOutlet weak var photoCaption: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    public func updateCell(insta: InstaModel) {
        userName.text = insta.userName
        photoCaption.text = insta.photoCaption
        profilePhoto.kf.setImage(with: URL(string: insta.userURL))
        userPhoto.kf.setImage(with: URL(string: insta.photoURL))
    }
}

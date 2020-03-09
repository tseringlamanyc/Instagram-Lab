//
//  ProfileCell.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/9/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    public func updateCell(insta: InstaModel) {
        userPhoto.kf.setImage(with: URL(string: insta.photoURL))
    }
}

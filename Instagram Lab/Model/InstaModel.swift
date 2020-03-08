//
//  InstaModel.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import Foundation

struct InstaModel {
    let photoCaption: String
    let uploadDate: Date
    let photoId: String    // document Id
    let photoURL: String
    let userName: String
    let userId: String
}

extension InstaModel {
    init(dictionary: [String: Any]) {
        self.photoCaption = dictionary["photoCaption"] as? String ?? "no caption"
        self.uploadDate = dictionary["uploadDate"] as? Date ?? Date()
        self.photoId = dictionary["photoId"] as? String ?? "no photoId"
        self.photoURL = dictionary["photoURL"] as? String ?? "no url"
        self.userName = dictionary["userName"] as? String ?? "no username"
        self.userId = dictionary["userId"] as? String ?? "no userId"
    }
}

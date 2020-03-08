//
//  StorageServices.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageServices {
    
    private let storageRef = Storage.storage().reference()
    
    public func uploadPhoto(userId: String? = nil, photoId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        var photoRef: StorageReference!
        
        if let userId = userId {
            photoRef = storageRef.child("UserProfilePhoto/\(userId).jpg")
        } else if let photoId = photoId {
            photoRef = storageRef.child("PhotoId/\(photoId).jpg")
        }
        
        let metadata = StorageMetadata()
        
        metadata.contentType = "image/jpg"
        
        let _ = photoRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else if let _ = metadata {
                photoRef.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}

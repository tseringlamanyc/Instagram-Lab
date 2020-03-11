//
//  DatabaseServices.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseServices {
    
    static let userPhotos = "userPhotos"
    
    private let db = Firestore.firestore()
    
    public func createPhoto(userName: String, photoCaption: String, location: String, completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        
        let document = db.collection(DatabaseServices.userPhotos).document()
        db.collection(DatabaseServices.userPhotos).document(document.documentID).setData(["photoCaption":photoCaption, "uploadDate": Timestamp(date: Date()), "photoId": document.documentID, "userName": userName, "userId": user.uid, "location": location]) { (error) in
            if let error = error {
                print("Error creating photo: \(error)")
                completion(.failure(error))
            } else {
                completion(.success(document.documentID))
            }
        }
    }
}

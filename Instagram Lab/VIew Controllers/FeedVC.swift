//
//  FeedVC.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import FirebaseFirestore


class FeedVC: UIViewController {

    @IBOutlet weak var feedCV: UICollectionView!
    
    private var listener: ListenerRegistration?
    
    private var posts = [InstaModel]() {
        didSet {
            self.feedCV.reloadData()
            if posts.isEmpty {
                feedCV.backgroundView = EmptyView(title: "Posts", message: "There are no posts yet")
            } else {
                feedCV.backgroundView = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        listener = Firestore.firestore().collection(DatabaseServices.userPhotos).addSnapshotListener({ [weak self](snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showStatusAlert(withImage: UIImage(systemName: "exclamationmark.triangle.fill"), title: "Firestore error", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map {InstaModel(dictionary: $0.data())}
                self?.posts = posts
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedCV.dataSource = self
        feedCV.delegate = self
        navigationItem.title = "FakerGram"
    }
}

extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCell else {
            fatalError()
        }
        let aPost = posts[indexPath.row]
        cell.updateCell(insta: aPost)
        return cell
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = UIScreen.main.bounds.size
        let width: CGFloat = maxsize.width
        let height: CGFloat = maxsize.height * 0.45
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

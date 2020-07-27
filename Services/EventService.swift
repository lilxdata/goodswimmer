//
//  EventService.swift
//  goodswimmer
//
//  Created by madi on 4/28/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

struct EventService {
        
    let db = Firestore.firestore()

    func createEvent(for image: UIImage, id: String)  {
        //make unique identifier for image
        let photoid = UUID().uuidString
        let imageRef = Storage.storage().reference().child(photoid+".jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            let urlString = downloadURL.absoluteString
            print("image URL: \(urlString)")
            
            self.db.collection("events").document(id).setData([
                "photoURL": urlString
                ], merge: true
                )
            
        }
    }
    
}

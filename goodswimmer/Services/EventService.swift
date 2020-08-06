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

class EventService {
        
    let db = Firestore.firestore()
    static let sharedInstance = EventService()

    func uploadImage(for image: UIImage, id: String)  {
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
    
    func createEvent(dictionary: [String: String], uuid: String) {
        db.collection("events").document(uuid).setData(dictionary, merge: true) { err in
                   if let err = err {
                       print("Error")
                   } else {
                       print("Document successfully written!")  // event created success pop up
                   }
               }
    }
}

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
    let db = Firestore.firestore() // Firebase database
    
    // Shared instances allows multiple view controllers to use these functions
    // without having to instantiate a new class each time
    let eventArray = EventArray.sharedInstance
    static let sharedInstance = EventService()
    
    
    // Uploads image using UIImage object type
    // Requires id for firebase storage as well as a filename
    func uploadImage(for image: UIImage, id: String, name: String)  {
        //make unique identifier for image
        let photoid = name
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
    
    
    // Creates an event in Firebase using the event dictionary model
    func createEvent(dictionary: [String: Any], uuid: String) {
        db.collection("events").document(uuid).setData(dictionary, merge: true) { err in
            if let err = err {
                print("Error creating event: ", err)
            } else {
                print("The event was successfully written to Firebase!")  // event created success pop up
            }
        }
    }
}

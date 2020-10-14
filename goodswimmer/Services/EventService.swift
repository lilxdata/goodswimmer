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
    let eventArray = EventArray.sharedInstance
    let db = Firestore.firestore()
    static let sharedInstance = EventService()

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
    
    func createEvent(dictionary: [String: Any], uuid: String) {
        db.collection("events").document(uuid).setData(dictionary, merge: true) { err in
                   if let err = err {
                       print("Error")
                   } else {
                       print("Document successfully written!")  // event created success pop up
                   }
               }
    }
    //Function can be moved to another location if necessary
    //Currently not static by imagine we only want users
    //to be filtering their events and not other classes
    func filterEvents(filter:String, cat: String) {
        print(filter,cat)
        db.collection("events").whereField("name", isEqualTo: "Monster giveaway")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting events: \(err)")
                } else {
                    for event in querySnapshot!.documents {
                        print("\(event.documentID) => \(event.data())")
                    }
                }
        }
    }
}

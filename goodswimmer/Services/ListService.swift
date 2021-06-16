//
//  ListService.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 12/28/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

// JUNE 2021 TODO: This feature works, next would be a view controller
// or more visual elements in the app to get the inputs needed to create
// and/or update a list object.

class ListService {
    let db = Firestore.firestore()
    // Creates a List object in Firebase
    func createList(dictionary: [String: Any], uuid: String) {
        db.collection("lists").document(uuid).setData(dictionary, merge: true) { err in
            if let err = err {
                print("Error")
            } else {
                print("Document successfully written!")  // event created success pop up
            }
        }
    }
}

///EXAMPLE OF HOW TO USE
//let listDict = [
// "username" : [Auth.auth().currentUser!.displayName],
// "userId" : Auth.auth().currentUser!.uid,
// "followers" : [],
// "listName" : "two",
// "description" : "Even another list",
// "events" : [],
// "places" : [],
// "createdDate": NSDate(timeIntervalSince1970:(NSDate().timeIntervalSince1970)) ,
// ] as [String : Any]
// let service = ListService()
// service.createList(dictionary: listDict, uuid: UUID().uuidString)
//

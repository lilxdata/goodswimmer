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

class ListService {
    let db = Firestore.firestore()
    
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

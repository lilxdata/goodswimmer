//
//  UserService.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 10/20/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class UserService {
    let db = Firestore.firestore()
    static let sharedInstance = UserService()
    
    func getCurrentBio() -> String {
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        var bioRetreived:String = ""        
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                bioRetreived =  document.get("bio") as? String ?? "Error retreiving bio"
            } else {
                bioRetreived = "Error retreiving bio"
            }
        }
        return bioRetreived
    }
    
    func createFirestoreUser(username: String, userID: String) {
        //This is the create user functionality, could benefit from a userService class
        let userDict = [
            "username":  username,
            "userId": userID,
            "following": [String](),
            "followers": [String](),
            "bio": ""
        ] as [String : Any]
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData(userDict, merge: true) { err in
            if let err = err {
                print("Error: ",err)
            } else {
                print("Added user to firebase successfully!")  // user created success pop up
            }
        }
    }
    
}

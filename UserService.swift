//
//  UserService.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 10/20/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import Firebase

// JUNE 2021 TODO: Create more placeholders for the new user generation

class UserService {
    let db = Firestore.firestore() // Firebase database
    // Shared instances allows multiple view controllers to use these functions
    // without having to instantiate a new class each time
    static let sharedInstance = UserService()
    
    
    // Retrieves the bio of the current user
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
    
    
    // Creates firebase user using username and userID, followers, following, and bio are blank
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

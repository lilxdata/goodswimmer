//
//  FirestoreHelper.swift
//  goodswimmer
//
//  Created by madi on 9/23/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreHelper {
    
    private let db = Firestore.firestore()
    
    // Current user follows user based on userID.
    func followUser(_ otherUserId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        // Get new write batch
        let batch = db.batch()

        // Set the followers array of person
        let otherUserRef = db.collection("users").document(otherUserId)
        batch.updateData(["followers": FieldValue.arrayUnion([currentUserId])], forDocument: otherUserRef)

        // Set following array of current user
        let currentUserRef = db.collection("users").document(currentUserId)
        batch.updateData(["following": FieldValue.arrayUnion([otherUserId]) ], forDocument: currentUserRef)
    
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
}

//
//  EventCell.swift
//  goodswimmer
//
//  Created by madi on 6/12/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import FirebaseFirestore
import FirebaseAuth

class UserSearchCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    
    
    var userToDisplay: User?
    
    @IBAction func followUser(_ sender: Any) {
        let db = Firestore.firestore()
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                    "followers" : FieldValue.arrayUnion([self.username.text!])
                ])
            } else {
                print("Error following user")
            }
        }
    }
    
    
    func displayUser(_ user: User) {
        userToDisplay = user
        let imageURL = URL(string: userToDisplay?.photoURL ?? Constants.Placeholders.placeholderURL)
        profileImage.sd_setImage(with: imageURL, completed: nil)
        bio.text =  userToDisplay?.bio
        username.text = userToDisplay?.username
        customizeElements()
    }
    
    func customizeElements() {
        Utilities.styleLabel(username, size: 15,  uppercase: false)
        Utilities.styleLabel(bio, size: 15,  uppercase: false)
    }
    
}

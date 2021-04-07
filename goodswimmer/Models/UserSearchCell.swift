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
                db.collection("users").document(self.userToDisplay?.userId ?? "").updateData([
                    "followers" : FieldValue.arrayUnion([Auth.auth().currentUser!.displayName])
                ])
                
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                    "following" : FieldValue.arrayUnion([self.username.text!])
                ])
            } else {
                print("Error following user")
            }
        }
    }
    
    
    func displayUser(_ user: User) {
        userToDisplay = user
        let imageURL = URL(string: userToDisplay?.photoURL ?? Constants.Placeholders.placeholderURL)
        self.profileImage.makeRounded(_cornerRadius: profileImage.frame.height)
        profileImage.sd_setImage(with: imageURL, completed: {image,_,_,_ in
            //self.profileImage.image = self.profileImage.image?.roundedImage
            //self.profileImage.makeRounded(_cornerRadius: profileImage.frame.height)
        })
        bio.text =  userToDisplay?.bio
        username.text = userToDisplay?.username
        if(userToDisplay?.username == Auth.auth().currentUser?.displayName) {
            followButton.isHidden = true
        }
        customizeElements()
    }
    
    func customizeElements() {
        Utilities.styleLabelBold(username, size: 15,  uppercase: false)
        Utilities.styleLabel(bio, size: 15,  uppercase: false)
        followButton.tintColor = Utilities.getRedUI()
    }
    
}

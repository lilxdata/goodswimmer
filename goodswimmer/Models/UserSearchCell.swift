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
    //TODO: ADD START DATE / END DATE, START TIME / END TIME
    func displayEvent(_ user: User) {
        userToDisplay = user
        
        let imageURL = URL(string: userToDisplay?.photoURL ?? Constants.Placeholders.placeholderURL)
        
        profileImage.sd_setImage(with: imageURL, completed: nil)
        customizeElements()
    }
    
    func customizeElements() {
        /*Utilities.styleLabel(, size: 35,  uppercase: false)
        Utilities.styleLabel(, size: 15, uppercase: false)
        Utilities.styleLabel(, size: 18, uppercase: false)
        Utilities.styleLabel(, size: 18, uppercase: false)
        Utilities.styleLabel(, size: 15, uppercase: false)*/
    }
    
}

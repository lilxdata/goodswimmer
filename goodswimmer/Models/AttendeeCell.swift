//
//  AttendeeCell.swift
//  goodswimmer
//
//  Created by madi on 10/7/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import SDWebImage

class AttendeeCell: UICollectionViewCell {
    
    @IBOutlet weak var attendeePic: UIImageView!
    var attendeeToDisplay: Attendee?
    override func layoutSubviews() {
        //everytime cell gets loaded this runs
        let attendeePicUrl = URL(string: attendeeToDisplay?.profileUrl ?? Constants.Placeholders.placeholderURL)
        attendeePic.sd_setImage(with: attendeePicUrl, completed: nil)
        
    }
    
    
}

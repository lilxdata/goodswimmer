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

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    var eventToDisplay: Event?
    func displayEvent(_ event: Event) {        
        let placeholderText = "Tba"
        eventToDisplay = event
        eventName.text = eventToDisplay!.name
        eventLocation.text = eventToDisplay?.venue ?? placeholderText
        eventDate.text = eventToDisplay?.date ?? placeholderText
        eventTime.text = eventToDisplay?.time ?? placeholderText
        
        let placeholderURL = "https://firebasestorage.googleapis.com/v0/b/good-swimmer.appspot.com/o/test_image.jpg?alt=media&token=7ab711db-332a-4cf1-a4b3-bb711b0def0c"
        let imageURL = URL(string: eventToDisplay?.photoURL ?? placeholderURL)
        
        eventImage.sd_setImage(with: imageURL, completed: nil)
        customizeElements()
    }
    
    func customizeElements() {
        Utilities.styleLabel(eventName, size: 35,  uppercase: false)
        Utilities.styleLabel(eventLocation, size: 15, uppercase: false)
        Utilities.styleLabel(eventDate, size: 24, uppercase: false)
        Utilities.styleLabel(eventTime, size: 24, uppercase: false)
    }
}

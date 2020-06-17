//
//  EventCell.swift
//  goodswimmer
//
//  Created by madi on 6/12/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    
    var eventToDisplay: Event?
    func displayEvent(_ event: Event) {
        print("in displayEvent func")
        eventToDisplay = event
        eventName.text = "placeholder"
        // eventToDisplay.text = received data 
        
        eventName.text = eventToDisplay!.name
        print("displaying event")
    }
}

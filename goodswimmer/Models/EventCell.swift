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
    @IBOutlet weak var username: UILabel!
    
    var eventToDisplay: Event?
    //TODO: ADD START DATE / END DATE, START TIME / END TIME
    func displayEvent(_ event: Event) {
        eventToDisplay = event
        username.text = eventToDisplay?.username ?? Constants.Placeholders.placeholderText
        eventName.text = eventToDisplay?.name ?? Constants.Placeholders.placeholderTitle
        eventLocation.text = eventToDisplay?.venue ?? Constants.Placeholders.placeholderText
                    
        //TODO: check if same month / diff month, same day diff day
        if let startDate = eventToDisplay?.startDate, let endDate = eventToDisplay?.endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E MMM d" //yy or yyyy for year
            eventDate.text = dateFormatter.string(from: startDate.dateValue())
            
            //TODO: format end date
            
            dateFormatter.dateFormat = "hh:mma"
            
            let startTimeString = dateFormatter.string(from: startDate.dateValue())
            let endTimeString = dateFormatter.string(from: endDate.dateValue())
            
            eventTime.text = startTimeString + "-" + endTimeString
            
        } else {
            print("in else")
            eventDate.text = Constants.Placeholders.placeholderText
        }
                
        let imageURL = URL(string: eventToDisplay?.photoURL ?? Constants.Placeholders.placeholderURL)
        
        eventImage.sd_setImage(with: imageURL, completed: nil)
        customizeElements()
    }
    
    func customizeElements() {
        Utilities.styleLabel(eventName, size: 35,  uppercase: false)
        Utilities.styleLabel(eventLocation, size: 15, uppercase: false)
        Utilities.styleLabel(eventDate, size: 24, uppercase: false)
        Utilities.styleLabel(eventTime, size: 24, uppercase: false)
        Utilities.styleLabel(username, size: 15, uppercase: false)
    }
}

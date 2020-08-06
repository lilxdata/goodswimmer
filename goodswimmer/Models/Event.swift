//
//  Event.swift
//  goodswimmer
//
//  Created by madi on 4/28/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import FirebaseDatabase

//event structure featuring all of the event data we need, title, date etc from firebase data
//TODO: update struct after db design implemented for events
struct Event {
    
    var name:String?
    var venue: String?
    var address:String?
    var description:String?
    var organizer:String?
    var date:String?
    var dateStart: String?
    var dateEnd: String?
    var photoURL:String?
    var time: String?
    
    init?(eventDict: [String: Any]) {
        let name = eventDict["name"] as? String
        let venue = eventDict["location"] as? String
        let dateStart = eventDict["date_start"] as? String
        //  let imageHeight = dict["image_height"] as? CGFloat,
        //  let createdAgo = dict["created_at"] as? TimeInterval
        self.name = name
        self.venue = venue
        self.dateStart = dateStart
        self.photoURL = eventDict["photoURL"] as? String
        //sd web image library -> imageView
    }
}

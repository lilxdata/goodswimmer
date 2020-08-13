//
//  Event.swift
//  goodswimmer
//
//  Created by madi on 4/28/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

//event structure featuring all of the event data we need, title, date etc from firebase data
//TODO: update struct after db design implemented for events
struct Event {
    
    var name:String?
    var venue: String?
    var address:String?
    var description:String?
    var username:String?
    var date:String?
    var dateStart: String?
    var startDate: Timestamp?
    var dateEnd: String?
    var photoURL:String?
    var time: String?
    
    init?(eventDict: [String: Any]) {
        let name = eventDict["name"] as? String
        let venue = eventDict["location"] as? String
        let time = eventDict["date_end"] as? String
        let username = eventDict["username"] as? String
        let description = eventDict["description"] as? String
        let dateStart = eventDict["date_start"] as? String //deprecated
        let startDate = eventDict["start_date"] as? Timestamp
        //  let imageHeight = dict["image_height"] as? CGFloat,
        //  let createdAgo = dict["created_at"] as? TimeInterval
        self.username = username
        self.name = name
        self.venue = venue
        self.dateStart = dateStart
        self.photoURL = eventDict["photoURL"] as? String
        self.time = time
        self.description = description
        self.startDate = startDate
    }
}

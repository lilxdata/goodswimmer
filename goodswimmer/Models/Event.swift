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
    //var urlToImage:String?
    var organizer:String?
    var date:String?
    var photoURL:String?
    
//    init?(snapshot: DataSnapshot) {
//        let eventData = snapshot.value as? [String : Any]
        
//        self.name = name
//        self.venue = venue
//        self.address = address
//        self.description = description
//        self.urlToImage = urlToImage
//        self.organizer = organizer
//        self.date = date
//    }
    
    
    init?(eventDict: [String: Any]) {
            let name = eventDict["name"] as? String
          //  let imageHeight = dict["image_height"] as? CGFloat,
          //  let createdAgo = dict["created_at"] as? TimeInterval
       self.name = name
        self.photoURL = eventDict["photoURL"] as? String
        //sd web image library -> imageView
    }
    
    
    //TODO: Photo data 
    
//}
}

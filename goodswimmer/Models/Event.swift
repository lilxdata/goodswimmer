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
    
    var title:String?
    var venue: String?
    var address:String?
    var description:String?
    var urlToImage:String?
    var organizer:String?
    var date:String?
    var photoUrl:String?
    
    //TODO: Photo data 
    
}

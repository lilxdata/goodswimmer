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
    var startDate: Timestamp?
    var endDate: Timestamp?
    var photoURL:String?
    var time: String?
    var userId: String? //todo
    var attendees: [Attendee]?
    private let accessibilityQs: [String]?
    var accessibilityAs: [Bool]?
    var otherDescription: String?
    var participants:String?
    var ticketPrice: Int?
    var inviteList:String?
    var inviteToGS: Bool?
    var inviteOnly: Bool?
    var streetNumber : String?
    var city : String?
    var state : String?
    var zipCode : String?
    var virtualEvent : Bool?
    private var createdDate: Timestamp?
    
    init?(eventDict: [String: Any]) {
        let name = eventDict["name"] as? String
        let venue = eventDict["location"] as? String
        let username = eventDict["username"] as? String
        let description = eventDict["description"] as? String
        let startDate = eventDict["start_date"] as? Timestamp
        let endDate = eventDict["end_date"] as? Timestamp
        let address = eventDict["address"] as? String
        let otherDescription = eventDict["description"] as? String
        let createdDate = eventDict["createdDate"] as? Timestamp
        let participants = eventDict["participants"] as? String
        let ticketPrice = eventDict["ticketPrice"] as? Int
        let inviteList = eventDict["inviteList"] as? String
        let inviteToGS = eventDict["inviteToGS"] as? Bool
        let inviteOnly = eventDict["inviteOnly"] as? Bool
        let streetNumber = eventDict["street number"] as? String
        let city = eventDict["city"] as? String
        let state = eventDict["state"] as? String
        let zipCode = eventDict["zip code"] as? String
        let virtualEvent = eventDict["virtualEvent"] as? Bool
        
        
        self.username = username
        self.name = name
        self.venue = venue
        self.address = address
        self.photoURL = eventDict["photoURL"] as? String
        self.endDate = endDate
        self.description = description
        self.startDate = startDate
        self.accessibilityQs = ["Wheelchair accessible", "Accessible Restroom",
                                "Scent-Free", "Close to Transit",
                                "NOTAFLOF", "Other"]
        self.accessibilityAs = [false, false, false, false, false, false]
        self.otherDescription = otherDescription
        self.createdDate = createdDate
        self.participants = participants
        self.ticketPrice = ticketPrice
        self.inviteList = inviteList
        self.inviteToGS = inviteToGS
        self.inviteOnly = inviteOnly
        self.streetNumber = streetNumber
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.virtualEvent = virtualEvent
    }
}

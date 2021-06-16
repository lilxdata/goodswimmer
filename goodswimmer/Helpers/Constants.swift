//
//  Constants.swift
//  goodswimmer_logincwc
//
//  Created by madi on 4/19/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation

// Page to keep track of constants used throughout the app

struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "homeVC"
        static let tabViewController = "tabVC"
        static let loginViewController = "loginVC"
        static let detailViewController = "detailVC"
    }
    
    struct Placeholders {
        static let placeholderURL = "https://firebasestorage.googleapis.com/v0/b/good-swimmer.appspot.com/o/goodswimmer%20stock%20profile.png?alt=media&token=174d3698-5a08-454d-805b-701997c68c61"
        static let placeholderText = "TBA"
        static let placeholderTitle = "Unnamed Event"
        static let placeholderProfileLink = "http://www.justincarder.net/good-swimmer"
        
        
    }
    struct LocalStorage {
        static let storedUsername = "storedUsername"
        static let storedUserId = "storedUserId"
    }
}

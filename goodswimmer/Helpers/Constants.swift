//
//  Constants.swift
//  goodswimmer_logincwc
//
//  Created by madi on 4/19/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "homeVC"
        static let tabViewController = "tabVC"
        static let loginViewController = "loginVC"
        static let detailViewController = "detailVC"
    }
    
    struct Placeholders {
        static let placeholderURL = "https://firebasestorage.googleapis.com/v0/b/good-swimmer.appspot.com/o/test_image.jpg?alt=media&token=7ab711db-332a-4cf1-a4b3-bb711b0def0c"
        static let placeholderText = "TBA"
        static let placeholderTitle = "Unnamed Event"
        static let placeholderSearch = "Users, spaces, lists, events..."
        
    }
    struct LocalStorage {
        static let storedUsername = "storedUsername"
        static let storedUserId = "storedUserId"
    }
}

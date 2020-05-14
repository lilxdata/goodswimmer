//
//  LocalStorageService.swift
//  goodswimmer
//
//  Created by madi on 5/13/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation

class LocalStorageService {
    static func saveCurrentUser(user: GSUser) {
        // Get standard user defaults
        
        let defaults = UserDefaults.standard
        defaults.set(user.userId, forKey: Constants.LocalStorage.storedUserId)
        defaults.set(user.username, forKey: Constants.LocalStorage.storedUsername)
    }
    
    static func loadCurrentUser() -> GSUser? {
        // Get standard user defaults
        
        let defaults = UserDefaults.standard
                let userId = defaults.value(forKey: Constants.LocalStorage.storedUserId) as? String
        let username = defaults.value(forKey: Constants.LocalStorage.storedUsername) as? String
        
        guard userId != nil || username != nil else {
            return nil
        }
        
        let user = GSUser(username: username, userId: userId)
        return user
    }
    
    static func clearCurrentUser() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: Constants.LocalStorage.storedUserId)
        defaults.set(nil, forKey: Constants.LocalStorage.storedUsername)
    }
    
}

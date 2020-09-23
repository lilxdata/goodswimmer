//
//  LocalStorageService.swift
//  goodswimmer
//
//  Created by madi on 7/15/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation

class LocalStorageService {
    static func saveCurrentUser(user: User) {
        // Get standard user defaults
        
        let defaults = UserDefaults.standard
        defaults.set(user.userId, forKey: Constants.LocalStorage.storedUserId)
        defaults.set(user.username, forKey: Constants.LocalStorage.storedUsername)
    }
    
    static func loadCurrentUser() -> User? {
        // Get standard user defaults
        
        let defaults = UserDefaults.standard
        let userId = defaults.value(forKey: Constants.LocalStorage.storedUserId) as? String
        let username = defaults.value(forKey: Constants.LocalStorage.storedUsername) as? String
        
        guard userId != nil || username != nil else {
            return nil
        }
        
        let user = User(username: username, userId: userId, following: [], followers: [])
        return user
    }
    
    static func clearCurrentUser() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: Constants.LocalStorage.storedUserId)
        defaults.set(nil, forKey: Constants.LocalStorage.storedUsername)
    }
    
}

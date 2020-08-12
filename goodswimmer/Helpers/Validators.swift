//
//  Validators.swift
//  goodswimmer
//
//  Created by madi on 5/1/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import UIKit

class Validators {
    
    /* email validation */
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
        
    }
    /* name validation */
    static func isNameValid(_ name: String) -> Bool {
        let nameRegEx = "/^[A-Za-z][A-Za-z\'\\-]+([\\ A-Za-z][A-Za-z\'\\-]+)*/"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
        
    }
    
    /* username validation */
    static func isUsernameValid(_ username: String) -> Bool {
        let usernameRegEx = "^[a-zA-Z0-9_-]+"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: username)
        
    }
    
    /* date validation */
    static func isDateValid(_ date: String) -> Bool {
        let usernameRegEx = "^(0[1-9]|1[012])\\/(0[1-9]|[12][0-9]|3[01])\\/(19|20)\\d\\d ([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: date)
        
    }
    
    /* city validation */
    static func isCityValid(_ city: String) -> Bool {
        return isNameValid(city)
    }
}

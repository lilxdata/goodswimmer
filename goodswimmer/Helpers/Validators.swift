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
    /* name validation */ //TODO: Why doesn't ' work?
    static func isNameValid(_ name: String) -> Bool {
        let nameRegEx = "[-a-zA-Z. ']{2,26}"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
        
    }
    
    /* username validation */
    static func isUsernameValid(_ username: String) -> Bool {
        let usernameRegEx = "^[a-zA-Z0-9._-]+$"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: username)
        
    }
    
    /* date validation */
    static func isDateValid(_ date: String) -> Bool {
        let dateRegEx = "^(?:(?:31(\\/|-|\\.)(?:0?[13578]|1[02]))\\1|(?:(?:29|30)(\\/|-|\\.)(?:0?[1,3-9]|1[0-2])\\2))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$|^(?:29(\\/|-|\\.)0?2\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\\d|2[0-8])(\\/|-|\\.)(?:(?:0?[1-9])|(?:1[0-2]))\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$"
        let datePred = NSPredicate(format:"SELF MATCHES %@", dateRegEx)
        return datePred.evaluate(with: date)
        
    }
    
    /* date validation */
    static func isTimeValid(_ time: String) -> Bool {
        let timeRegEx = "^([0]{1}[1-9]{1}|[1]{1}[0-2]{1})[:]{1}[0-5]{1}[0-9]\\ {0,1}[apAP]{1}[mM]{1}$"
        let timePred = NSPredicate(format:"SELF MATCHES %@", timeRegEx)
        return timePred.evaluate(with: time)
        
    }
    
    /* street/number validation */
    static func isStreetNumberValid(_ addr: String) -> Bool {
        let addrRegEx = "[0-9]{5}\\ [-a-zA-Z. ']{2,26}"
        let addrPred = NSPredicate(format:"SELF MATCHES %@", addrRegEx)
        return addrPred.evaluate(with: addr)
        
    }
    
    /* zipcode validation */
    static func isZipCodeValid(_ addr: String) -> Bool {
        let addrRegEx = "[0-9]{5}"
        let addrPred = NSPredicate(format:"SELF MATCHES %@", addrRegEx)
        return addrPred.evaluate(with: addr)
        
    }
    
    /* city,state validation */
    static func isCityStateValid(_ addr: String) -> Bool {
        let addrRegEx = "[-a-zA-Z. ']{2,26}\\,(|AL|AK|AS|AZ|AR|CA|CO|CT|DE|DC|FM|FL|GA|GU|HI|ID|IL|IN|IA|KS|KY|LA|ME|MH|MD|MA|MI|MN|MS|MO|MT|NE|NV|NH|NJ|NM|NY|NC|ND|MP|OH|OK|OR|PW|PA|PR|RI|SC|SD|TN|TX|UT|VT|VI|VA|WA|WV|WI|WY|)"
        let addrPred = NSPredicate(format:"SELF MATCHES %@", addrRegEx)
        return addrPred.evaluate(with: addr)
        
    }
    
    /* city validation */
    /* to do; google places API to check it's actually a city*/
    static func isCityValid(_ city: String) -> Bool {
        let cityRegEx = "[A-Z][A-Za-z\\s]+"
        let cityPred = NSPredicate(format:"SELF MATCHES %@", cityRegEx)
        return cityPred.evaluate(with: city)
    }
}

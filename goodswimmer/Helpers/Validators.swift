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
        let nameRegEx = "[-a-zA-Z. '\']{2,56}"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
        
    }
    
    /* username validation */
    static func isUsernameValid(_ username: String) -> Bool {
        let usernameRegEx = "^[a-zA-Z0-9._-]+$"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: username)
        
    }
    static func isDateValidHelper(month: String, day: String, year: String, is_leap: Bool) -> Bool{
        if(["2"].contains(month)){
            //If not a leap year, return false
            if((Int(day) ?? 30) > 28){
                if(is_leap && day == "29"){
                    return true
                }
                return false
            }
            return true
        }
        else if(["4","6","9","11"].contains(month)){
            if((Int(day) ?? 32) > 31){
                return false
            }
            return true
        }
        else if(["1","3","5","7","8","10","12"].contains(month)){
            if((Int(day) ?? 32) > 31){
                return false
            }
            return true
        }
        return false
    }
    /* date validation
       TODO: Implement mm/d/yyyy, m/d/yyyy, mm/dd/yy, mm/dd/yy, m/dd/yy, m/d/yy
    */
    static func isDateValid(_ date: String) -> Bool {
        //Let's check if the date is m/dd/yyyy
        let dateRegEx1 = "([1-9])[-\\/](0[1-9]|[12][0-9]|3[01])[-\\/.](19|20|21|22|23|24)[0-9][0-9]"
        let datePred1 = NSPredicate(format:"SELF MATCHES %@", dateRegEx1)
        //Let's check if the date is mm/dd/yyyy
        let dateRegEx2 = "(0[1-9]|1[012])[-\\/.](0[1-9]|[12][0-9]|3[01])[-\\/.](19|20|21|22|23|24)[0-9][0-9]"
        let datePred2 = NSPredicate(format:"SELF MATCHES %@", dateRegEx2)
         
        //Tester
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        var adjusted_date = ""
        //Setup Checks
        if(datePred1.evaluate(with: date) == true) {
            adjusted_date = "0"+date
        }
        else if(datePred2.evaluate(with: date) == true) {
            adjusted_date = date
        }
        if dateFormatter.date(from: adjusted_date) != nil {
            return true
        }
        else { return false }
        
    }
    
    static func isLeap(year: Int) -> Bool {
        let year_int = Int(year)
        if(year_int % 400 == 0) {
            return true
        }
        else if(year_int % 100 == 0) {
            return false
        }
        else if(year_int % 4 == 0) {
            return true
        }
        return false
    }
    
    /* date validation */
    static func isTimeValid(_ time: String) -> Bool {
        let timeRegEx = "^([0]{0,1}[1-9]{1}|[1]{1}[0-2]{1})[:]{1}[0-5]{1}[0-9]\\ {0,1}[apAP]{1}[mM]{1}$"
        let timePred = NSPredicate(format:"SELF MATCHES %@", timeRegEx)
        return timePred.evaluate(with: time)
        
    }
    
    /* street/number validation */
    static func isStreetNumberValid(_ addr: String) -> Bool {
        let addrRegEx = "[0-9]{1,8}\\ [-a-zA-Z0-9. '\']{2,26}"
        let addrPred = NSPredicate(format:"SELF MATCHES %@", addrRegEx)
        return addrPred.evaluate(with: addr)
        
    }
    
    /* zipcode validation */
    static func isZipCodeValid(_ addr: String) -> Bool {
        let addrRegEx = "[0-9]{5}"
        let addrPred = NSPredicate(format:"SELF MATCHES %@", addrRegEx)
        return addrPred.evaluate(with: addr)
        
    }
    
    /* state validation */
    static func isStateValid(_ addr: String) -> Bool {
        let addrRegEx = "(|AL|AK|AS|AZ|AR|CA|CO|CT|DE|DC|FM|FL|GA|GU|HI|ID|IL|IN|IA|KS|KY|LA|ME|MH|MD|MA|MI|MN|MS|MO|MT|NE|NV|NH|NJ|NM|NY|NC|ND|MP|OH|OK|OR|PW|PA|PR|RI|SC|SD|TN|TX|UT|VT|VI|VA|WA|WV|WI|WY|)"
        let addrPred = NSPredicate(format:"SELF MATCHES %@", addrRegEx)
        return addrPred.evaluate(with: addr)
        
    }
    
    /* city validation */
    /* to do; google places API to check it's actually a city*/
    static func isCityValid(_ city: String) -> Bool {
        let cityRegEx = "[0-9A-Z][A-Za-z\\s]+"
        let cityPred = NSPredicate(format:"SELF MATCHES %@", cityRegEx)
        return cityPred.evaluate(with: city)
    }
    
    /* city,state validation */
    static func isCityStateValid(_ addr: String) -> Bool {
        let addrRegEx = "[0-9-a-zA-Z.' \']{2,26}\\,[ ]{0,1}(|AL|AK|AS|AZ|AR|CA|CO|CT|DE|DC|FM|FL|GA|GU|HI|ID|IL|IN|IA|KS|KY|LA|ME|MH|MD|MA|MI|MN|MS|MO|MT|NE|NV|NH|NJ|NM|NY|NC|ND|MP|OH|OK|OR|PW|PA|PR|RI|SC|SD|TN|TX|UT|VT|VI|VA|WA|WV|WI|WY|)"
        let addrPred = NSPredicate(format:"SELF MATCHES %@", addrRegEx)
        return addrPred.evaluate(with: addr)
        
    }
    
    
    /* location validation */
    static func isLocationValid(_ city: String) -> Bool {
        let cityRegEx = ".{2,126}"
        let cityPred = NSPredicate(format:"SELF MATCHES %@", cityRegEx)
        return cityPred.evaluate(with: city)
    }
}

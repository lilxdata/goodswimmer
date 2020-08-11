//
//  Utilities.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield: UITextField, size: Int) {
        // create bottom line detail
        let bottomLine = CALayer()
        let fontSize = CGFloat(size)
        bottomLine.frame = CGRect( x:0, y:textfield.frame.height + 5, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        textfield.layer.addSublayer(bottomLine)
        textfield.textColor = UIColor.black
        textfield.font = UIFont(name: "Standard-Book", size: fontSize)
    }
    
    static func styleDisabledTextField(_ textfield: UITextField, size: Int) {
        // create bottom line detail
        let bottomLine = CALayer()
        let fontSize = CGFloat(size)
        bottomLine.frame = CGRect( x:0, y:textfield.frame.height + 5, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.systemGray2.cgColor
        textfield.layer.addSublayer(bottomLine)
        textfield.textColor = UIColor.black
        textfield.font = UIFont(name: "Standard-Book", size: fontSize)
    }
    
    
    static func styleHeader(_ label: UILabel){
        label.font = UIFont(name: "Career_salle13_cursive", size: 20)
        label.textColor = UIColor.black
        label.text = label.text?.uppercased()
    }
    
    static func styleSubHeader(_ label:UILabel) {
        label.font = UIFont(name: "CutiveMono-Regular", size: 21)
        label.textColor = UIColor.black
    }
    
    static func styleLabel(_ label: UILabel, size: Int, uppercase: Bool){
        let fontSize = CGFloat(size)
        label.font = UIFont(name: "Standard-Book", size: fontSize)
        if uppercase {
            label.text = label.text?.uppercased()
        }
    }
    
    static func styleButton(_ button: UIButton) {
        //rounded button
        button.titleLabel?.font = UIFont(name: "Standard-Book", size: 21)
        // button.layer.cornerRadius = 20.0
        // button.title = button.titleLabel?.text?.uppercased() // did not work
        button.setTitle(button.title(for: .normal)?.uppercased(), for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        
    }
    
    static func styleError(_ label: UILabel) {
        styleSubHeader(label)
        label.textColor = UIColor.red
        label.numberOfLines = 0
    }
    
    /* password validation */
    static func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func cleanData(_ field: UITextField) -> String {
        return field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func isFilledIn(_ fields: [UITextField]) -> Bool {
        for field in fields {
            if field == nil {
                print ("oops! you didn't fill everything in!")
                break
            } else {
                return true
            }
        }
        return false
    }
    
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
        let usernameRegEx = "^(0[1-9]|1[012])\\/(0[1-9]|[12][0-9]|3[01])\\/(19|20)\\d\\d ([01][0-9]|2[0-3]):([0-5][0-9])$"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: date)
        
    }
}

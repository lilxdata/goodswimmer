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
    
    static func styleTextField(_ textfield: UITextField) {
    // create bottom line detail
        let bottomLine = CALayer()
        bottomLine.frame = CGRect( x:0, y:textfield.frame.height + 5, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        textfield.layer.addSublayer(bottomLine)
        textfield.textColor = UIColor.black
        textfield.font = UIFont(name: "Standard-Book", size: 24)
//        textfield.attributedPlaceholder.font = UIFont(name: "Standard-Book", size: 15)
//        textfield.attributedText.text
//        let placeholderText = NSAttributedString(string: textfield.placeholder!, attributes: [NS UIFont(name: "Standard-Book", size: 15))
        
//       textfield.attributedPlaceholder = placeholderText
    }
    
    static func styleTextFieldRed(_ textfield: UITextField) {
    // create bottom line detail
        let bottomLine = CALayer()
        bottomLine.frame = CGRect( x:0, y:textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.red.cgColor
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleHeader(_ label: UILabel){
        /* add code to style headers and make consistent across app */
        label.font = UIFont(name: "Career_salle13_cursive", size: 54)
        label.textColor = UIColor.black
        label.text = label.text?.uppercased()
    }
    
    static func styleAppName(_ label: UILabel) {
        label.font = UIFont(name: "Career_salle13_cursive", size: 20)
        label.textColor = UIColor.black
        label.text = label.text?.uppercased()
    }
    
    static func styleSubHeader(_ label:UILabel) {
        label.font = UIFont(name: "CutiveMono-Regular", size: 21)
        label.textColor = UIColor.black
    }
    
    static func styleText(_ label: UILabel){
        label.font = UIFont(name: "Standard-Book", size: 24)
    }
    
    static func styleButton(_ button: UIButton) {
        //rounded button
        button.titleLabel?.font = UIFont(name: "Standard-Book", size: 21)
       // button.layer.cornerRadius = 20.0 
        button.setTitle(button.title(for: .normal)?.uppercased(), for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    static func styleError(_ label: UILabel) {
        styleSubHeader(label)
        label.textColor = UIColor.red
        label.numberOfLines = 0
    }
    
    static func styleCheckbox(_ button: UIButton) {
        button.tintColor = UIColor.black
    }
    
    static func styleBoxChecked(_ button: UIButton) {
        button.tintColor = UIColor.black
        button.backgroundColor = UIColor.red
    }
    
    /* password validation */
    static func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func cleanTextField(_ textfield: UITextField) -> String {
        return textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // TODO: email validation
}

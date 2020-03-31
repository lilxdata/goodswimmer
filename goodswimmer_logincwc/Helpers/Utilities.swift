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
    bottomLine.frame = CGRect( x:0, y:textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.black.cgColor
        
        textfield.layer.addSublayer(bottomLine)
    
    }
    
    static func styleHeader(_ label: UILabel){
        /* add code to style headers and make consistent across app */
    }
    
    static func styleButton(_ button: UIButton) {
        //rounded button
        button.layer.cornerRadius = 20.0
    }
    
    /* password validation */
    static func isPasswordValid(_ password: String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}

//
//  Menu.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 1/10/21.
//  Copyright © 2021 madi. All rights reserved.
//

import Foundation
import UIKit
import Firebase


// This is a class of helper functions made to help manage pop ups.
// JUNE 2021 TODO: Like with the style functions, this needs to be planned
// out before making anymore new screens so that everything happens
// programatically.

class Menu {
    static let sharedInstance = Menu()
    
    @objc func closeAddTolistMenu(_sender: UIButton!) {
        _sender.superview?.isHidden = true
    }
    
    @objc func closePopUp(_sender: UIView) {
        _sender.superview?.isHidden = true
    }
}

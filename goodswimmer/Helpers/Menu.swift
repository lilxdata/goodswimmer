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

class Menu {
    static let sharedInstance = Menu()
    
    @objc func closeAddTolistMenu(_sender: UIButton!) {
        _sender.superview?.isHidden = true
        
    }
    
}

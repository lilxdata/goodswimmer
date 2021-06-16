//
//  Navigation.swift
//  goodswimmer
//
//  Created by madi on 7/24/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import UIKit

// Class used to navigate between different view controllers.
// JUNE 2021: Moving in a new screen from left should be done here.

class Navigation  {
    //TODO: add for all VC transitions
    static let sharedInstance = Navigation()
    func goHome() -> UITabBarController? {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        guard let tabViewController = mainSB.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? UITabBarController else {
            return nil
        }
        
        tabViewController.modalPresentationStyle = .fullScreen
        return tabViewController
    }
}

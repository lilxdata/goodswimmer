//
//  Notifications.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 4/21/21.
//  Copyright © 2021 madi. All rights reserved.
//

import Foundation
import UIKit

// This class was made to display the pop ups seen in good swimmer
 
class Notifications: UIView {
    // Adds a success pop up with given input as message
    func addSuccessPopUp(_sender: UIView, message: String) {
        //Initialize frame
        let xPos = 80//(_sender.frame.width)*0.1
        let yPos = 200//(_sender.frame.height)*0.1
        let width = 255//(_sender.frame.width)*0.8
        let height = 318//(_sender.frame.height)*0.7
        let successMessageButton = UIButton(type: UIButton.ButtonType.system)
        successMessageButton.frame = CGRect(x: xPos, y: yPos, width:width, height:height)
        
        //Add close mechanism
        successMessageButton.addTarget(self, action: #selector(self.closeNotif), for: .touchUpInside)
        
        //Customize Notification Display
        successMessageButton.setTitle(message, for: .normal)
        self.styleNotification(button: successMessageButton)
               
        //Add view to viewcontroller view
        _sender.addSubview(successMessageButton)
    }
    
    // Closes the notification
    @objc func closeNotif(sender: UIView) {
        //Close the view
        sender.removeFromSuperview()
    }
    
    func styleNotification(button: UIButton){
        button.titleLabel?.font = UIFont(name: "CutiveMono-Regular", size: 21)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .top
    
        button.backgroundColor = Utilities.getRedUI()
        button.titleLabel?.numberOfLines = 100
        button.titleLabel?.textAlignment = .center
        
    }
    

    // Adds a  pop up with given input as message
    func showHomeAll(_sender: UIView, message: String) {
        //Initialize frame
        let xPos = 48
        let yPos = 144
        let width = 318
        let height = 475
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: xPos, y: yPos, width:width, height:height)
        
        //Customize Notification Display
        button.setTitle(message, for: .normal)
        button.titleLabel?.font = UIFont(name: "CutiveMono-Regular", size: 21)
        button.setTitleColor(Utilities.getRedUI(), for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .top
        button.backgroundColor = UIColor.white
        button.titleLabel?.numberOfLines = 100
        button.titleLabel?.textAlignment = .center
               
        //Add view to viewcontroller view
        _sender.addSubview(button)
    }
    
    // Adds a  pop up with given input as message
    func searchShowAll(_sender: UIView, message: String) {
        //Initialize frame
        let xPos = 48
        let yPos = 144
        let width = 318
        let height = 130
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: xPos, y: yPos, width:width, height:height)
        
        //Customize Notification Display
        button.setTitle(message, for: .normal)
        button.titleLabel?.font = UIFont(name: "CutiveMono-Regular", size: 21)
        button.setTitleColor(Utilities.getRedUI(), for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .top
        button.backgroundColor = UIColor.white
        button.titleLabel?.numberOfLines = 100
        button.titleLabel?.textAlignment = .center
               
        //Add view to viewcontroller view
        _sender.addSubview(button)
    }
    
}

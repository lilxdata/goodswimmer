//
//  Notifications.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 4/21/21.
//  Copyright © 2021 madi. All rights reserved.
//

import Foundation
import UIKit

class Notifications: UIView {
    
        
    
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
    
    
    @objc func closeNotif(sender: UIView) {
        //Close the view
        sender.removeFromSuperview()
    }
    
    func styleNotification(button: UIButton){
        button.titleLabel?.font = UIFont(name: "CutiveMono-Regular", size: 21)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .top
        //button.layer.borderColor = Utilities.getRedCG()
        //button.layer.borderWidth = 1
    
        button.backgroundColor = Utilities.getRedUI()//UIColor.white
        button.titleLabel?.numberOfLines = 100
        button.titleLabel?.textAlignment = .center
        
    }
}

//
//  CalendarViewController.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 12/6/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

// Template for a page with just a calendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var testEventButton: UIButton!
    
    
    var eventsToday: [Event?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        var todaysEvents = ""
        for event in eventsToday {
            todaysEvents += (event?.name ?? "") + "\n"
        }
        testEventButton.titleLabel?.numberOfLines = 10
        testEventButton.setTitle(todaysEvents, for: .normal
        )
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpElements() {
        print("setting up stuff")
    }
    
    
    
    
}

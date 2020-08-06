//
//  DetailViewController.swift
//  goodswimmer
//
//  Created by madi on 5/6/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var eventHeader: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventLocation: UILabel!
    
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       // let image = selectedEvent?.photoURL
        setUpElements()
        if let event = selectedEvent {
            let photoURL = event.photoURL ?? Constants.Placeholders.placeholderURL
            let title = event.name ?? Constants.Placeholders.placeholderTitle
            let location = event.venue ?? Constants.Placeholders.placeholderText
            eventTitle.text = title
            eventLocation.text = location
        }
        
        
    }
    
    func setUpElements() {
        Utilities.styleLabel(eventTitle, size: 35, uppercase: false)
        
        Utilities.styleLabel(eventHeader, size: 15, uppercase: true)
        
        Utilities.styleLabel(eventLocation, size: 15, uppercase: false)
    }
    
}

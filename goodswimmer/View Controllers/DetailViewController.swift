//
//  DetailViewController.swift
//  goodswimmer
//
//  Created by madi on 5/6/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let image = selectedEvent?.photoURL
        
        if let event = selectedEvent {
            let photoURL = event.photoURL
            let title = event.name ?? "Unnamed Event"
            eventTitle.text = title
        }
        
        
    }
    
}

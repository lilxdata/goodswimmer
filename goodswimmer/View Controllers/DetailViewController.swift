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
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
       
        if let event = selectedEvent {
            let photoURL = URL(string: event.photoURL ?? Constants.Placeholders.placeholderURL)
            let title = event.name ?? Constants.Placeholders.placeholderTitle
            let location = event.venue ?? Constants.Placeholders.placeholderText
            let date = event.dateStart ?? Constants.Placeholders.placeholderText
            let time = event.time ?? Constants.Placeholders.placeholderText
            let desc = event.description ?? Constants.Placeholders.placeholderText
            
            eventTitle.text = title
            eventLocation.text = location
            eventImage.sd_setImage(with: photoURL, completed: nil)
            eventDate.text = date
            eventTime.text = time
            eventDesc.text = desc
        }
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpElements() {
        Utilities.styleLabel(eventTitle, size: 35, uppercase: false)
        Utilities.styleLabel(eventHeader, size: 15, uppercase: true)
        Utilities.styleLabel(eventLocation, size: 15, uppercase: false)
        Utilities.styleLabel(eventDate, size: 24, uppercase: false)
        Utilities.styleLabel(eventTime, size: 24, uppercase: false)
        Utilities.styleLabel(eventDesc, size: 15, uppercase: false)
    }
    
}

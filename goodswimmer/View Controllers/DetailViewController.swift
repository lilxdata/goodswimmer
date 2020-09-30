//
//  DetailViewController.swift
//  goodswimmer
//
//  Created by madi on 5/6/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    // @IBOutlet weak var eventHeader: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    
    
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        if let event = selectedEvent {
            let photoURL = URL(string: event.photoURL ?? Constants.Placeholders.placeholderURL)
            let title = event.name ?? Constants.Placeholders.placeholderText
            let location = event.venue ?? Constants.Placeholders.placeholderText
            let date = event.startDate!
            //TODO: make a timestamp obj placeholder for optional unwrapping ?? Constants.Placeholders.placeholderText
            let time = event.time ?? Constants.Placeholders.placeholderText
            let description = event.description ?? Constants.Placeholders.placeholderText
            
            eventTitle.text = title
            eventLocation.text = location
            eventImage.sd_setImage(with: photoURL, completed: nil)
            //   eventDate?.text = date
            eventTime.text = time
            eventDesc.text = description
        }
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addToList(_ sender: Any) {
        print("add to list button tapped")
    }
    
    
    @IBAction func viewButtonTapped(_ sender: Any) {
        print("view button tapped")
    }
    
    
    @IBAction func followButtonTapped(_ sender: Any) {
        print("follow button tapped")
    }
    
    func setUpElements() {
        
        let eventHeader = navBar.topItem?.title ?? "EVENT"
        Utilities.styleEventHeader(eventHeader)
        Utilities.styleLabel(eventTitle, size: 35, uppercase: false)
        Utilities.styleLabel(eventLocation, size: 15, uppercase: false)
        Utilities.styleLabel(eventDate, size: 24, uppercase: false)
        Utilities.styleLabel(eventTime, size: 24, uppercase: false)
        Utilities.styleLabel(eventDesc, size: 15, uppercase: false)
    }
    
}

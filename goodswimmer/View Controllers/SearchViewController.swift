//
//  SearchViewController.swift
//  goodswimmer
//
//  Created by madi on 5/31/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var filterButton: UIButton!
    @IBAction func filterResults(_ sender: UIButton) {
        eventService.filterEvents(filter: "name", cat: "a")
    }

    //access to eventarray across app
    let eventArray = EventArray.sharedInstance
    let eventService = EventService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        filterResults(filterButton)
        eventService.filterEvents(filter: "a", cat: "name")
    }
}

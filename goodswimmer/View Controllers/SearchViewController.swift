//
//  SearchViewController.swift
//  goodswimmer
//
//  Created by madi on 5/31/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var filterButton: UIButton!
    @IBAction func filterResults(_ sender: UIButton) {
        filterResultsArray(filter: "Monster giveaway", category: "name")
    }
    func filterResultsArray(filter: String, category : String) {
        for event in eventArray.events {
            if(category == "name"){
                if(event.name == filter){
                    print(event)
                }
            }
        }
    }
    
    
    
    //access to eventarray across app
    let eventArray = EventArray.sharedInstance
    let eventService = EventService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        filterResults(filterButton)
        eventService.filterEvents(filter: "luhmow", cat: "name")
    }
}

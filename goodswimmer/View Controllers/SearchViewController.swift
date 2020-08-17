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
        print("I am using the button")
        filterSearchBar(searchBar, textDidChange:searchBar.text!)
    }
    
    // This method updates filteredData based on the text in the Search Box
    func filterSearchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("I am using ", searchText)
        filterResultsArray(filter:searchText, category:"name")
    }

    func filterResultsArray(filter: String, category : String) { 
        for event in eventArray.events {
            if(category == "name"){
                if(event.name?.contains(filter) == true){
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
        
    }
}

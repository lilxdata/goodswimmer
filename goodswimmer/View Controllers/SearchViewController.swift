//
//  SearchViewController.swift
//  goodswimmer
//
//  Created by madi on 5/31/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var searchController: UISearchController!
    
    //access to eventarray across app
    let eventArray = EventArray.sharedInstance
    let eventService = EventService()
    
    @IBOutlet var searchContainerView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Event Filter"
        
    }
    
    func filterEvents(_ searchTerm: String){
        print(searchTerm)
        for event in eventArray.events {
            print(event)
            if(event.name == searchTerm){
                print(event)
            }
        }
    }
    
     @IBAction func filterButtonPress(_ sender: Any) {
        print("I am using the button")
        //print(isSearchBarEmpty)
        //print(searchBar.text!)
        //print(searchController.searchBar.text!)
        //filterSearchBar(searchBar, textDidChange:searchBar.text!)
    }

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterEvents(searchText)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text {
            filterEvents(searchText)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchBar.text = ""
        }
    }
}

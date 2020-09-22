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
        for event in eventArray.events {
            //If our searchTerm is really small then no need to preform lcs
            if(searchTerm.count < 3){
                if(event.name?.contains(searchTerm) == true){
                    print(event)
                }
            }
            else {
                if(lcs(X: event.name!, Y: searchTerm) > 3){
                    print(event)
                }
            }
        }
    }
    func lcs(X :String, Y :String) -> Int{
        //find the length of the strings
        let m = X.count
        let n = Y.count
        // declaring the array for storing the dp values
        var L = Array(repeating: Array(repeating: 0, count: m+1), count: n+1)
        /*Following steps build L[m+1][n+1] in bottom up fashion
        Note: L[i][j] contains length of LCS of X[0..i-1]
        and Y[0..j-1]*/
        for i in 0...m+1{
            for j in 0...n+1{
                if(i == 0 || j == 0) {
                    L[i][j] = 0
                }
                else if(X[X.index(X.startIndex, offsetBy: i-1)] == Y[Y.index(Y.startIndex, offsetBy: j-1)]) {
                    L[i][j] = L[i-1][j-1]+1
                }
                else {
                    L[i][j] = max(L[i-1][j] , L[i][j-1])
                }
            }
        }
        /// L[m][n] contains the length of LCS of X[0..n-1] & Y[0..m-1]
        print(L)
        return L[m][n]
    }
    
     @IBAction func filterButtonPress(_ sender: Any) {
        print("I am using the button")
        print("testing lcs")
        let lcsT = lcs(X:"AGGTAB",Y: "GXTXAYB")
        print("lcs expected is 4, lcs is ",lcsT)
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

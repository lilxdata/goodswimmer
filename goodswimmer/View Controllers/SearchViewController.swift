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
                if(editDis(X: event.name!, Y: searchTerm) < event.name!.count/3){
                    print(event)
                }
            }
        }
    }
    func editDis(X :String, Y :String) -> Int{
        //find the length of the strings
        let m = X.count
        let n = Y.count
        //Create a table to store results of subproblems
        var dp = Array(repeating: Array(repeating: 0, count: n+1), count: m+1)
        // Fill dp[][] in bottom up manner
        for i in 0...m+1{
            for j in 0...n+1{
                //If first string is empty, only option is to
                //insert all characters of second string
                if(i == 0) {
                    dp[i][j] = j
                }
                //If second string is empty, only option is to
                //remove all characters of second string
                else if(j == 0) {
                    dp[i][j] = i
                }
                //If last characters are same, ignore last char
                //and recur for remaining string
                else if(X[X.index(X.startIndex, offsetBy: i-1)] == Y[Y.index(Y.startIndex, offsetBy: j-1)]) {
                    dp[i][j] = dp[i-1][j-1]
                }
                //If last character are different, consider all
                //possibilities and find minimum
                else {
                    dp[i][j] = min(dp[i-1][j]    //Insert
                                  ,dp[i][j-1],   //Erase
                                   dp[i-1][j-1]) //Substitute
                }
            }
        }
        print(dp)
        return dp[m][n]
    }
    
     @IBAction func filterButtonPress(_ sender: Any) {
        print("I am using the button")
        print("I am testing edit distance")
        let editDistance = editDis(X:"AGGTAB",Y: "GXTXAYB")
        print("lcs expected is 4, editDistance is ",editDistance)
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

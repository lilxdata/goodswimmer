//
//  SearchViewController.swift
//  goodswimmer
//
//  Created by madi on 5/31/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    var searchController: UISearchController!
    
    //access to eventarray across app
    let eventArray = EventArray.sharedInstance
    let eventService = EventService()
    
    @IBOutlet var searchContainerView: UIView!    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var featuredLabel: UILabel!    
    @IBOutlet weak var mappedEvent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for an Event!"
        
        
        //Map Stuff
        setUpElements()
        
        //Initialize Location with Woodstock Music Festival
        setMapLocation(address: "200 Hurd Rd, Swan Lake, NY 12783")

        
        
    }
    
    func filterEvents(_ searchTerm: String,_ update: Bool){
        var topEventEditDistance = [2^32,2^32] //[Current,Previous]
        var topEvent = Event(eventDict: ["name": ""])
        for event in eventArray.events {
            //If our searchTerm is really small then no need to preform edit distance
            if(searchTerm.count < 3){
                if(event.name?.contains(searchTerm) == true){
                    print(event)
                }
            }
            else {
                topEventEditDistance[0] = editDis(X: (event.name!).lowercased(), Y: searchTerm.lowercased())
                if(topEventEditDistance[0] < 10){
                    print(event)
                    //print(event.address!)
                    if(topEventEditDistance[0] < topEventEditDistance[1]) {
                        topEvent = event
                        topEventEditDistance[1] = topEventEditDistance[1]
                    }
                }
            }
        }
        if topEvent?.address != nil {
            self.setMapLocation(address: (topEvent?.address)!)
        }
        if topEvent != nil {
            let eventName = topEvent?.name ?? "Event Name Missing"
            let eventAddr = topEvent?.address ?? "Event Address Missing"
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-YYYY"
            let date = topEvent?.startDate?.dateValue()
            let dateString = formatter.string(from: date ?? NSDate() as Date)
            print("Selected", dateString)
            self.mappedEvent.text = eventName + "\n"  + eventAddr + "\n" + dateString
            
        }
    }
    
    func editDis(X :String, Y :String) -> Int{
        print(X,Y)
        //find the length of the strings
        let m = X.count
        let n = Y.count
        //Create a table to store results of subproblems
        var dp = Array(repeating: Array(repeating: 0, count: n+1), count: m+1)
        // Fill dp[][] in bottom up manner

        for i in 0...m{ //swift for loops are inclusive!
            for j in 0...n{
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

                    dp[i][j] = 1 + min(dp[i-1][j]    //Insert
                                  ,dp[i][j-1],   //Erase
                                   dp[i-1][j-1]) //Substitute
                }
            }
        }
        return dp[m][n]
    }
    func setUpElements() {
        Utilities.customizeSearchBar(searchController)
        Utilities.styleLabel(featuredLabel, size: 12, uppercase: true)
        Utilities.styleLabel(mappedEvent, size: 12, uppercase: true)
        mappedEvent.numberOfLines = 3
        mappedEvent.textAlignment = .center
    }
    
    func setMapLocation(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                return
            }
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let regionRadius: CLLocationDistance = 1000
            
            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            self.mapView.setRegion(coordinateRegion, animated: true)
  
            // Use your location
        }
    }


}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterEvents(searchText,false)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text {
            filterEvents(searchText, true)
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchBar.text = ""
        }
    }
}

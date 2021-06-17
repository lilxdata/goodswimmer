//
//  SearchViewController.swift
//  goodswimmer
//
//  Created by madi on 5/31/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class SearchViewController: UIViewController {
    var searchController: UISearchController!
    
    //access to eventarray across app
    let eventArray = EventArray.sharedInstance
    let eventService = EventService()
    
    
    
    @IBOutlet var searchContainerView: UIView!    
    @IBOutlet weak var mapView: MKMapView!   
    @IBOutlet weak var mappedEvent: UILabel!
    @IBOutlet weak var searchStack: UIStackView!
    @IBOutlet weak var topUserDisplay: UIButton!
    @IBOutlet weak var topEventDisplay: UIButton!
    @IBOutlet weak var topListDisplay1: UIButton!
    @IBOutlet weak var topListDisplay2: UIButton!
    @IBOutlet weak var temporaryShowAllEventsButton: UIButton!
    
    
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
        
        
        let notif = Notifications()
        notif.searchShowAll(_sender: self.view, message: "For testing purposes you can click below for a full list of everything happening on the app!\n\nALL USERS")
        let showAll = view.subviews[2] as! UIButton
        showAll.addTarget(self, action: #selector(self.displayUserList), for: .touchUpInside)
    }
    
    @IBAction func followAllUsersForAllEvents(_ sender: Any) {
        let db = Firestore.firestore()
        let users = db.collection("users").order(by: "username")
        users.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let userID = document.get("userId") as! String
                    let username = document.get("username") as! String
                    db.collection("users").document(userID).updateData([
                        "followers" : FieldValue.arrayUnion([Auth.auth().currentUser!.displayName!])
                    ])
                    
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                        "following" : FieldValue.arrayUnion([username])
                    ])
                    
                }}}}
    
    func searchForTopUser(_ searchTerm: String){
        var topUserEditDistance = [2^32,2^32] //[Current,Previous]
        var topUser = User(following: [""], followers: [""], events: [""])
        let db = Firestore.firestore()
        let users = db.collection("users")
        users.whereField("username", isEqualTo: searchTerm).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting users: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let userBio = document.get("bio") as? String ?? "No User Found"
                    let userUsername = document.get("username") as? String ?? ""
                    let topUserLabel = userUsername + "\n" + userBio
                    self.topUserDisplay.setTitle(topUserLabel, for: .normal)
                    topUserEditDistance[1] = topUserEditDistance[0]
                    
                }
            }
        }
        
    }
    
    func filterEvents(_ searchTerm: String,_ update: Bool){
        var topEventEditDistance = [2^32,2^32] //[Current,Previous]
        var topEvent = Event(eventDict: ["name": ""])
        for event in eventArray.events {
            let name = event.name!.prefix(searchTerm.count)
            topEventEditDistance[0] = editDis(X: (name).lowercased(), Y: searchTerm.lowercased())
            if(topEventEditDistance[0] < 10){
                if(topEventEditDistance[0] < topEventEditDistance[1]) {
                    topEvent = event
                    topEventEditDistance[1] = topEventEditDistance[0]
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
            self.mappedEvent.text = eventName + "\n"  + eventAddr + "\n" + dateString
            let topEventLabel = eventName + "\n" + (topEvent?.description ?? "Event Description Missing")
            topEventDisplay.setTitle(topEventLabel, for: .normal)
            
        }
    }
    
    func editDis(X :String, Y :String) -> Int{
        //print(X,Y)
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
        Utilities.styleLabel(mappedEvent, size: 12, uppercase: true)
        mappedEvent.numberOfLines = 3
        mappedEvent.textAlignment = .center
        topUserDisplay.titleLabel?.numberOfLines = 3
        topUserDisplay.backgroundColor = Utilities.getRedUI()
        topUserDisplay.tintColor = UIColor.white
        topEventDisplay.titleLabel?.numberOfLines = 3
        topEventDisplay.backgroundColor = Utilities.getRedUI()
        topEventDisplay.tintColor = UIColor.white
        topListDisplay1.titleLabel?.numberOfLines = 3
        topListDisplay1.backgroundColor = Utilities.getRedUI()
        topListDisplay1.tintColor = UIColor.white
        topListDisplay2.titleLabel?.numberOfLines = 3
        topListDisplay2.backgroundColor = Utilities.getRedUI()
        topListDisplay2.tintColor = UIColor.white
        
        temporaryShowAllEventsButton.setTitleColor(Utilities.getRedUI(), for: .normal)
        temporaryShowAllEventsButton.titleLabel?.textAlignment = .center
        temporaryShowAllEventsButton.titleLabel?.font = UIFont(name: "CutiveMono-Regular", size: 21)
        temporaryShowAllEventsButton.setTitle("ALL EVENTS", for: .normal)
        
        hideSearchResults(isHidden: true)
        self.mapView.isHidden = true
        self.mappedEvent.isHidden = true
        self.topListDisplay1.isHidden = true
        self.topListDisplay2.isHidden = true
        self.topUserDisplay.isHidden = true
        self.topEventDisplay.isHidden = true
        self.searchContainerView.isHidden = true
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
        }
    }
    
    func hideSearchResults(isHidden: Bool){
        for elem in searchStack.arrangedSubviews {
            if(elem == topUserDisplay){
                elem.isHidden = isHidden
            }
            else if(elem == topEventDisplay){
                elem.isHidden = isHidden
            }
            else if(elem == topListDisplay1){
                elem.isHidden = isHidden
            }
            else if(elem == topListDisplay2){
                elem.isHidden = isHidden
            }
            else if(elem == mapView){
                elem.isHidden = isHidden
            }
            else if(elem == mappedEvent){
                elem.isHidden = isHidden
            }
        }
    }
    
    @objc func displayUserList(_ sender: Any) {
        let resultsView  = storyboard!.instantiateViewController(withIdentifier: "search_res_vc") as! SearchResultsViewController
        self.present(resultsView, animated: true, completion: nil)
    }
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //Search Bar Results
        if let searchText = searchController.searchBar.text {
            if(searchText.count < 1){
                hideSearchResults(isHidden: true)
            }
            else {
                hideSearchResults(isHidden: true)
            }
            filterEvents(searchText,false)
            searchForTopUser(searchText)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text {
            filterEvents(searchText, true)
            searchForTopUser(searchText)
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchBar.text = ""
            hideSearchResults(isHidden: true)
        }
    }
}

//
//  HomeViewController.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //If no events, display zero state page
    
   // var events = [[Event]]() as? [[String: Any]]
    var events =  [Event]()
    var eventsStatic = ["First event", "another event", "third event"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        let db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        //TODO: refresh control
        
       // read from events collection
        //TODO: check out snapshot listener 
        db.collection("events").getDocuments { (querySnapshot, error) in
            if error == nil && querySnapshot != nil {
                for document in querySnapshot!.documents {
                    print("document received")
                    let eventData = document.data()
                    if let event = Event(eventDict: eventData) {
                        self.events.append(event)
                    }
                }
                self.tableView.reloadData()
            }
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
    
    func setUpElements() {
        Utilities.styleHeader(headerLabel)
        
    }
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell //cast as event cell
        
        //get event
        let event = events[indexPath.row]
        
        //customize cell
        cell.displayEvent(event)
        
        // return cell
        return cell
    }
    
      //called everytime cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("table")
        //events[indexPath.row].name
       // prepare(for: detailSegue)
        //detailSegue
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController {
            vc.selectedEvent = events[indexPath.row]
            vc.selectedTitle = events[indexPath.row].name
            vc.selectedImage = events[indexPath.row].photoURL
            
            performSegue(withIdentifier: "detailSegue", sender: Any?.self)

           // navigationController?.pushViewController(vc, animated: true)

        }
       // prepare(for: detailSegue, sender: <#T##Any?#>)
       // prepare(for: UIStoryboardSegue, sender: Any?)
        
    }
}

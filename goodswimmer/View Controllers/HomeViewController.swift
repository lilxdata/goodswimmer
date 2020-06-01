//
//  HomeViewController.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
  //  var events = [Event]()
    var eventsStatic = ["First event", "another event", "third event"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        let db = Firestore.firestore()

       // read single document
//        db.collection("events").document("event2").getDocument { (docSnapshot, error) in
//            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                //display document
//
//            }
//        }
        
        //read collection of documents
//        db.collection("events").getDocuments { (querySnapshot, error) in
//            if error == nil && querySnapshot != nil {
//                for document in querySnapshot!.documents {
//                    // display data
//                }
//            }
//        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsStatic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)
        cell.textLabel!.text=eventsStatic[indexPath.row]
        
        return cell
    }
    

    
    
}




//extension HomeViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return events.count
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // get event cell
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
//
//        //get event
//        let event = events[indexPath.row]
//
//        cell.displayEvent(event)
//        return cell
//    }

    
//}

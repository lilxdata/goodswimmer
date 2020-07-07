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
    

    @IBOutlet weak var tableView: UITableView!
    //If no events, display zero state page
    
   // var events = [[Event]]() as? [[String: Any]]
    var events =  [Event]()
    var eventsStatic = ["First event", "another event", "third event"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        //TODO: refresh control

      //  read single document
//        db.collection("events").document("event2").getDocument { (docSnapshot, error) in
//            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
//               print("reading event data")
//
//
//            }
//        }
        
       // read from events collection
        db.collection("events").getDocuments { (querySnapshot, error) in
            if error == nil && querySnapshot != nil {
                for document in querySnapshot!.documents {
                    
                 //   self.events!.append(document.data())
//                    self.label.text = self.events![0]["name"]! as! String
                   // count+=1
                }
        }
            self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell //cast as event cell
        
        //get article
        let event = events[indexPath.row]
        
        //customize cell
        
        cell.displayEvent(event)
        
        // return cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("table")
    }
   
    
}

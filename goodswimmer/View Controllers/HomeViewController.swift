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
    @IBOutlet weak var zeroStateView: UIView!
    
    let eventArray = EventArray.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        let db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        //TODO: refresh control
        
        // read from events collection
        //TODO: check out snapshot listener 
        db.collection("events").order(by: "start_date").addSnapshotListener { (querySnapshot, error) in
            if error == nil && querySnapshot != nil {
                //clear event array to remove dupes
                self.eventArray.events.removeAll()
                for document in querySnapshot!.documents {
                    print("document received")
                    let eventData = document.data()
                    if let event = Event(eventDict: eventData) {
                        self.eventArray.events.append(event)
                    }
                }
                self.tableView.reloadData()
                if self.eventArray.events.count == 0 {
                    self.zeroStateView.isHidden = false
                }
            }
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    }
    
    func setUpElements() {
        Utilities.styleHeader(headerLabel)
    }
    
    @IBAction func inviteFriend(_ sender: Any) {
        print("invite friend button pressed")
    }
    
    @IBAction func addToList(_ sender: Any) {
        print("add to list button pressed")
    }
    
    @IBAction func addToCal(_ sender: Any) {
        print("add to calendar button pressed")
    }
    
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventArray.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell //cast as event cell
        
        //get event
        let event = self.eventArray.events[indexPath.row]
        
        //customize cell
        cell.displayEvent(event)
        
        // return cell
        return cell
    }
    
    //called everytime cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  self.performSegue(withIdentifier: "detailSegue2", sender: <#T##Any?#>)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC2") as? DetailViewController {
            vc.selectedEvent = self.eventArray.events[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

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
    @IBOutlet weak var sortBySwitch: UISwitch!
    @IBOutlet weak var sortByLabel: UILabel!
    
    let eventArray = EventArray.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        tableView.delegate = self
        tableView.dataSource = self
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        /*
        let listDict = [
            "username" : Auth.auth().currentUser!.displayName,
            "userId" : Auth.auth().currentUser!.uid,
            "followers" : [],
            "description" : "Test Description",
            "events" : [],
            "places" : [],
            "createdDate": NSDate(timeIntervalSince1970:(NSDate().timeIntervalSince1970)) ,
        ] as [String : Any]
        let service = ListService()
        service.createList(dictionary: listDict, uuid: Auth.auth().currentUser!.uid)
        */
        /*let xPos = (self.view.frame.width)*0.1
        let yPos = (self.view.frame.height)*0.3
        let testView = UIView(frame: CGRect(x: xPos, y: yPos, width:320, height:400))
      
        testView.backgroundColor = UIColor.orange
        self.view.addSubview(testView)
        
        var button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: 0, y: 0, width:320, height:200)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
            
        button.setTitle("Create your List!", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .left
        testView.addSubview(button)*/
    }
    
    @objc func pressed(_sender: UIButton!) {
        print("I pressed")
    }
    
    func setUpElements() {
        Utilities.styleHeader(headerLabel)
        Utilities.styleLabel(sortByLabel, size: 12, uppercase: false)
        sortByLabel.textAlignment = .right
        sortTableView(sortBy: "start_date")
        sortBySwitch.clipsToBounds = true
        sortBySwitch.layer.cornerRadius = 1 * sortBySwitch.frame.height / 2.0
        sortBySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        sortBySwitch.onTintColor = .orange
        sortBySwitch.tintColor = .orange
        sortBySwitch.backgroundColor = .orange
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
    
    @IBAction func sortByUpdate(_ sender: Any) {
        if(sortBySwitch.isOn) {
            sortByLabel.text = "Event Date"
            sortTableView(sortBy: "start_date")
            sortBySwitch.onTintColor = .orange
            sortBySwitch.tintColor = .orange
            sortBySwitch.backgroundColor = .orange
        }
        else {
            sortByLabel.text = "Date Posted"
            sortTableView(sortBy: "createdDate")
            sortBySwitch.tintColor = .blue
            sortBySwitch.backgroundColor = .blue
        }
    }
    
    func sortTableView(sortBy: String){
        let db = Firestore.firestore()
        db.collection("events").order(by: sortBy).addSnapshotListener { (querySnapshot, error) in
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

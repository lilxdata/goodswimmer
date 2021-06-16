//
//  HomeViewController.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var zeroStateView: UIView!
    @IBOutlet weak var sortBySwitch: UISwitch!
    @IBOutlet weak var sortByLabel: UILabel!
    
    let eventArray = EventArray.sharedInstance
    let menu = Menu.sharedInstance
    
    
    var event = Event(eventDict: ["eventName" : "PlaceHolder"])
    let maxButton = 10
    var numOfLists = 0
    var buttonArray = [UIButton](repeating: UIButton(type: UIButton.ButtonType.custom), count: 10)
    let notClicked = UIImage.imageWithColor(color: .white, size: CGSize(width: 50, height: 50))
    let clicked = UIImage.imageWithColor(color: .black, size: CGSize(width: 50, height: 50))
    let animated = UIImage.imageWithColor(color: Utilities.getRedUI(), size: CGSize(width: 50, height: 50))
    var viewAll = false
    
    var notif: Notifications?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notif = Notifications()
        
        
        setUpElements()
        tableView.delegate = self
        tableView.dataSource = self
        
        sortBySwitch.isHidden = true
        sortByLabel.isHidden = true
        
        // Sets up zero state view
        notif!.showHomeAll(_sender: self.zeroStateView, message: "Oh hi! Welcome to Good Swimmer\n\nThis screen is your feed. Normally, events will appear here from people, spaces, and lists you follow.\n\nFor testing purposes, click below for a full view of users and events!\n\nALL USERS\n\nALL EVENTS")
        let showAll = zeroStateView.subviews[1] as! UIButton
        showAll.addTarget(self, action: #selector(self.revealAll), for: .touchUpInside)
    }
    
    
    // Reveal all events in the Home View Controller
    @objc func revealAll(sender: UIButton) {
        self.viewAll = true
        self.sortTableView(sortBy: "start_date")
    }
    
    @objc func pressed(_sender: UIButton!) {
        if(_sender.image(for: .normal) == notClicked) {
            _sender.setImage(clicked, for: .normal)
        }
        else if(_sender.image(for: .normal) == clicked){
            _sender.setImage(notClicked, for: .normal)
        }
    }
    
    @objc func closeAddTolistMenu(_sender: UIButton!) {
        _sender.superview?.superview?.isHidden = true
    }
    
    
    func setUpListMenuButton(button: UIButton){
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.setTitle("Create your List!", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .center
        //List Row
        let listRowCheckBoxFrame = CGRect(x: 0, y: 0, width:40, height:50)
        
        let listRowCheckBoxCG = CIContext().createCGImage(CIImage(color: .white), from: listRowCheckBoxFrame)!
        
        let listCheckBox = UIImage(cgImage: listRowCheckBoxCG)
        button.setImage(self.notClicked, for: .normal)
        button.setImage(self.animated, for: .selected)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets.left = 10
        button.isHidden = true
        
        
    }
    
    func showUser(username: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let profile_view  = storyboard.instantiateViewController(withIdentifier: "profile_vc") as! ProfileViewController
        
        profile_view.profileOwner.username = username
        if(username == Auth.auth().currentUser?.displayName){
            profile_view.isCurUser = true
        }
        else {profile_view.isCurUser = false}
        
        let nav = self.navigationController //grab an instance of the current navigationController
        DispatchQueue.main.async { //make sure all UI updates are on the main thread.
            nav?.view.layer.add(CATransition().segueFromLeft(), forKey: nil)
            nav?.pushViewController(profile_view, animated: false)
        }
        
        
        self.present(profile_view, animated: true, completion: nil)
    }
    
    func setUpElements() {
        Utilities.styleHeader(headerLabel)
        Utilities.styleLabel(sortByLabel, size: 12, uppercase: false)
        sortByLabel.textAlignment = .right
        sortTableView(sortBy: "start_date")
        sortBySwitch.clipsToBounds = true
        sortBySwitch.layer.cornerRadius = 1 * sortBySwitch.frame.height / 2.0
        sortBySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        sortBySwitch.onTintColor = Utilities.getRedUI()
        sortBySwitch.tintColor = Utilities.getRedUI()
        sortBySwitch.backgroundColor = Utilities.getRedUI()
    }
    
    func addSuccessNotif(message: String){
        self.notif?.addSuccessPopUp(_sender: self.view, message: message)
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
        db.collection("users").whereField("username", isEqualTo: Auth.auth().currentUser?.displayName)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //let x = self.event?.username
                        var followers = document.get("following") as! [String]
                        db.collection("events").order(by: sortBy).addSnapshotListener { (querySnapshot, error) in
                            if error == nil && querySnapshot != nil {
                                //clear event array to remove dupes
                                self.eventArray.events.removeAll()
                                for document in querySnapshot!.documents {
                                    let eventData = document.data()
                                    let eventDate = (document.get("start_date") as! Timestamp).dateValue()
                                    let currentDate = NSDate() as Date
                                    let eventUsername = document.get("username") as! String
                                    print("I am getting events")
                                    print(self.viewAll)
                                    print(eventData)
                                    if(self.viewAll || (eventDate > currentDate && (followers.contains(eventUsername) || eventUsername == Auth.auth().currentUser?.displayName))){
                                        print("am I getting here?")
                                        if let event = Event(eventDict: eventData) {
                                            self.eventArray.events.append(event)
                                        }
                                        print(self.eventArray.events)
                                    }
                                }
                                self.tableView.reloadData()
                                print(self.eventArray.events.count)
                                if self.eventArray.events.count == 0 {
                                    self.zeroStateView.isHidden = false
                                }
                                else {
                                    self.zeroStateView.isHidden = true
                                }
                            }
                        }
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
        
        cell.viewcontroller = self
        
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


extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize=CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}




extension CATransition {
    
    //New viewController will appear from bottom of screen.
    func segueFromBottom() -> CATransition {
        self.duration = 0.375 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromTop
        return self
    }
    //New viewController will appear from top of screen.
    func segueFromTop() -> CATransition {
        self.duration = 0.375 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromBottom
        return self
    }
    //New viewController will appear from left side of screen.
    func segueFromLeft() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
    //New viewController will pop from right side of screen.
    func popFromRight() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.reveal
        self.subtype = CATransitionSubtype.fromRight
        return self
    }
    //New viewController will appear from left side of screen.
    func popFromLeft() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.reveal
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
}

//
//  EventCell.swift
//  goodswimmer
//
//  Created by madi on 6/12/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import FirebaseFirestore
import FirebaseAuth

// This class is the model for the Events displayed on
// the homescreen. Each event shown is represented by
// one event cell.

class EventCell: UITableViewCell {
    
    // Outlets connected to elements on storyboard
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var inviteButton: UIButton!    
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var addToListButton: UIButton!
    @IBOutlet weak var addToCalendarButton: UIButton!
    
    // Reference to HomeViewController
    weak var viewcontroller: HomeViewController?
    
    // Event contains the information displayed for a given cell
    var eventToDisplay: Event?
    
    // The programattic aspect of the home screen is done here
    func displayEvent(_ event: Event) {
        eventToDisplay = event
        usernameButton.setTitle(eventToDisplay?.username, for: .normal)
        eventName.text = eventToDisplay?.name ?? Constants.Placeholders.placeholderTitle
        eventLocation.text = eventToDisplay?.venue ?? Constants.Placeholders.placeholderText
        
        //TODO: check if same month / diff month, same day diff day
        if let startDate = eventToDisplay?.startDate, let endDate = eventToDisplay?.endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM dd, yyyy" //yy or yyyy for year
            eventDate.text = dateFormatter.string(from: startDate.dateValue())
            
            //TODO: format end date
            
            dateFormatter.dateFormat = "hh:mma"
            
            var startTimeString = dateFormatter.string(from: startDate.dateValue())
            var endTimeString = dateFormatter.string(from: endDate.dateValue())
            
            if(startTimeString.first == "0"){
                startTimeString.remove(at: startTimeString.startIndex)
            }
            if(endTimeString.first == "0"){
                endTimeString.remove(at: endTimeString.startIndex)
            }
            
            eventTime.text = startTimeString + "-" + endTimeString
            
        } else {
            print("in else")
            eventDate.text = Constants.Placeholders.placeholderText
        }
        
        let imageURL = URL(string: eventToDisplay?.photoURL ?? Constants.Placeholders.placeholderURL)
        
        eventImage.sd_setImage(with: imageURL, completed: nil)
        customizeElements()
    }
    
    
    // Style's elements in the event cell
    func customizeElements() {
        Utilities.styleLabel(eventName, size: 35,  uppercase: false)
        Utilities.styleLabel(eventLocation, size: 15, uppercase: false)
        Utilities.styleLabel(eventDate, size: 18, uppercase: false)
        Utilities.styleLabel(eventTime, size: 18, uppercase: false)
        Utilities.styleLabel(usernameButton.titleLabel!, size: 15, uppercase: false)
        usernameButton.setTitleColor(.black, for: .normal)
    }
    
    
    // Adds the event to logged in user's calendar
    @IBAction func addToCalendar(_ sender: Any) {
        //print(self.eventName.text)
        //print(self.tableView.hashValue)
        let db = Firestore.firestore()
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                    "events" : FieldValue.arrayUnion([self.eventName.text!])
                ])
                document.get("events")
                self.viewcontroller?.addSuccessNotif(message: "You added this event to your calendar!")
            } else {
                print("Error adding event")
            }
        }      
    }
    
    
    
    // Adds the event creator to logged in user's following list
    @IBAction func addToFollowing(_ sender: Any) {
        let db = Firestore.firestore()
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                    "followers" : FieldValue.arrayUnion([self.username.text!])
                ])
            } else {
                print("Error following user")
            }
        }
    }
    
    // Brings Up user's profile view when the username element is tapped on the event cell.
    @IBAction func usernamePressed(_ sender: Any) {
        viewcontroller?.showUser(username: (usernameButton.titleLabel?.text)!) 
    }
}

//
//  DetailViewController.swift
//  goodswimmer
//
//  Created by madi on 5/6/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DetailViewController: UIViewController, UICollectionViewDelegate,
                            UICollectionViewDataSource {
        
    @IBOutlet weak var navBar: UINavigationBar!
    // @IBOutlet weak var eventHeader: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var attendeeGrid: UICollectionView!
    
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        attendeeGrid.delegate = self
        attendeeGrid.dataSource = self
        
        
        
        if let event = selectedEvent {
            let df = DateFormatter()
            df.dateFormat = "EEEE, MMM dd"
            
            let photoURL = URL(string: event.photoURL ?? Constants.Placeholders.placeholderURL)
            let title = event.name ?? Constants.Placeholders.placeholderText
            let location = event.venue ?? Constants.Placeholders.placeholderText
            let date = event.startDate!.dateValue()
            let description = event.description ?? Constants.Placeholders.placeholderText
            
            eventTitle.text = title
            eventLocation.text = location
            eventImage.sd_setImage(with: photoURL, completed: nil)
            eventDate.text = df.string(from: date)
            print("I am trying to get the date as a string", df.string(from: date))
            df.dateFormat = "hh:mma"
            print("I am trying to get the time as a string", df.string(from: date))
            eventTime.text = df.string(from: date)
            if(eventTime.text?.first == "0"){
                eventTime.text?.remove(at: eventTime.text!.startIndex)
            }
            eventDesc.text = description
        }
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToCal(_ sender: Any) {
        let username = selectedEvent?.username
             print("add to cal button tapped")
             CalendarHelper.addToCalendar(event: selectedEvent!, userid: username!)
             CalendarHelper.attendEvent(event: selectedEvent!, userid: username!)
    }

    @IBAction func shareEvent(_ sender: Any) {
        print("share event button tapped")
    }
    @IBAction func addToList(_ sender: Any) {
        print("add to list button tapped")
    }
    
    func setUpElements() {
        
        let eventHeader = navBar.topItem?.title ?? "EVENT"
        Utilities.styleEventHeader(eventHeader)
        Utilities.styleLabel(eventTitle, size: 35, uppercase: false)
        Utilities.styleLabel(eventLocation, size: 15, uppercase: false)
        Utilities.styleLabel(eventDate, size: 24, uppercase: false)
        Utilities.styleLabel(eventTime, size: 24, uppercase: false)
        Utilities.styleLabel(eventDesc, size: 15, uppercase: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     //   return selectedEvent?.attendees?.count ?? 0 //number of attendees
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let attendee = selectedEvent?.attendees?[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attendeeCell", for: indexPath) as? AttendeeCell else {
            return UICollectionViewCell()
        }
        
        cell.attendeeToDisplay = attendee
        return cell
        
        
    }
    
    @IBAction func addToFollowers(_ sender: Any) {
        let db = Firestore.firestore()
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        let otherUser = self.selectedEvent?.username!
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                    "following" : FieldValue.arrayUnion([otherUser])
                ])
            } else {
                print("Error following user")
            }
        }
        db.collection("users").whereField("username", isEqualTo: otherUser).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting other user: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    db.collection("users").document(document.get("userId") as! String).updateData([
                        "followers" : FieldValue.arrayUnion([Auth.auth().currentUser?.displayName])
                    ])
                }
            }
        }
    }
    @IBAction func addToCalendar(_ sender: Any) {
        let db = Firestore.firestore()
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                    "events" : FieldValue.arrayUnion([self.selectedEvent?.name!])
                ])
            } else {
                print("Error adding event")
            }
        }
    }
}

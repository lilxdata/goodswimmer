//
//  CreateEventViewController.swift
//  goodswimmer
//
//  Created by madi on 5/13/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

class CreateEventViewController: UIViewController {

    //connect IBOutlets
    
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventParticipants: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventDesc: UITextField!
    
    
    @IBOutlet weak var createEventField: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // on create event tapped
    // connect to db
    // write data to events collection

   
    @IBAction func createEventTapped(_ sender: Any) {
        let db = Firestore.firestore()
       
        db.collection("events").addDocument(data: [
            "name": eventName!,
            "description": eventDesc!]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
   
    
    
    
    //TODO later: validation on fields
    //fields are filled in, locations are searched, character limits, etc
}

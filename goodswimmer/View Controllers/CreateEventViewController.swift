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
    
    @IBOutlet weak var eventName: UITextField!
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
       
        //creaate cleaned version of data 
        let name = Utilities.cleanTextField(eventName)
      //  let participants = Utilities.cleanTextField(eventParticipants)
//        let location = Utilities.cleanTextField(eventLocation)
        let desc = Utilities.cleanTextField(eventDesc)
        
        let db = Firestore.firestore()
       
        db.collection("events").addDocument(data: [
            "name": name,
            "description": desc
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        //go back to home screen
        //TODO - extract this into utilities or make separate function
       let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController)  as? HomeViewController
       
       view.window?.rootViewController = homeViewController
       view.window?.makeKeyAndVisible()
    }
   
    
    
    
    //TODO later: validation on fields
    //fields are filled in, locations are searched, character limits, etc
}

//
//  CreateEventViewController.swift
//  goodswimmer
//
//  Created by madi on 5/13/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class CreateEventViewController: UIViewController {

    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var createEventHeader: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressField1: UITextField!
    @IBOutlet weak var addressField2: UITextField!
    @IBOutlet weak var addressField3: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateField1: UITextField!
    @IBOutlet weak var dateField2: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createEventButton: UIButton!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    
    let photoHelper = PhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let labelSize = 12
        let fieldSize = 15
        let headerSize = 35
        
        //label styling
        let labels = [titleLabel, locationLabel,descriptionLabel, dateLabel, addressLabel, imageLabel]
        
        for label in labels {
            stackView.setCustomSpacing(16, after: label!)
            Utilities.styleLabel(label!, size: labelSize, uppercase: true)
        }
        
        let textfields = [titleField, locationField, dateField1, dateField2]
        
        for textfield in textfields {
            Utilities.styleTextField(textfield!, size: fieldSize)
        }
        
        Utilities.styleDisabledTextField(addressField1,size: fieldSize)
        Utilities.styleDisabledTextField(addressField2, size: fieldSize)
        Utilities.styleDisabledTextField(addressField3, size: fieldSize)
   
        Utilities.styleButton(createEventButton)
        Utilities.styleLabel(createEventHeader, size: headerSize, uppercase: false)
        
        descriptionText.layer.borderColor = UIColor.black.cgColor
        descriptionText.layer.borderWidth = 1
        
        //TODO: disable address field until location field is filled out - make it some sort of state, once location is put in, check DB if it exists, if not enable address  field, then send noti to us to send postcard inviting them to join. if location does exist, populate with address
        
        //TODO: add red asterisks to mandatory categories; helper isMandatory or something
        
       // delegate = self
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        print("In add image tapped")
        photoHelper.completionHandler =  { image in
            EventService.createEvent(for: image)
        }
        photoHelper.presentActionSheet(from: self)
    }
    
    
    @IBAction func createEventTapped(_ sender: Any) {
        //write to DB
        let db = Firestore.firestore()
        
        //TODO: check that all fields are filled in!

        let eventName = Utilities.cleanData(titleField)
        let location = Utilities.cleanData(locationField)
        let date_start = Utilities.cleanData(dateField1)
        let date_end = Utilities.cleanData(dateField2)
        let address1 = Utilities.cleanData(addressField1)
        let address2 = Utilities.cleanData(addressField2)
        let address3 = Utilities.cleanData(addressField3)
        
        let description = descriptionText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //TODO: add photo URL and organizer name, validate

        db.collection("events").addDocument(data: [
            "name": eventName,
            "description": description,
            "location": location,
            "date_start": date_start,
            "date_end": date_end,
            "address1": address1,
            "address2": address2,
            "address3": address3
        ]) { err in
            if let err = err {
              //  self.showError("Error creating event!")
                print("Error")
            } else {
                print("Document successfully written!")  // event created success pop up
            }
        }
        
        self.transitionToHome()
        //some sort of validation - all fields filled out, doesn't currently exist, etc
        
        //then transition to home screen with event populated in feed
        
    }
    
//    func showError(_ message:String)  {
//         errorLabel.text! = message
//         errorLabel.alpha = 1
//         Utilities.styleError(errorLabel)
//     }
    
    func transitionToHome() {
        
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController)
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    
}

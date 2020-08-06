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
import FirebaseAuth

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
    
    let eventService = EventService.sharedInstance
    let photoHelper = PhotoHelper()
    var uuid = ""
    
    //runs everytime page is shown
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //generate unique id for each event
        uuid = UUID().uuidString
        
    }
    
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
        
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        photoHelper.completionHandler =  { image in
            self.eventService.uploadImage(for: image, id: self.uuid)
        }
        photoHelper.presentActionSheet(from: self)
    }
    
    
    @IBAction func createEventTapped(_ sender: Any) {
        //TODO: check that all fields are filled in!
        
        let eventName = Utilities.cleanData(titleField)
        let location = Utilities.cleanData(locationField)
        let date_start = Utilities.cleanData(dateField1)
        let date_end = Utilities.cleanData(dateField2)
        let address1 = Utilities.cleanData(addressField1)
        let address2 = Utilities.cleanData(addressField2)
        let address3 = Utilities.cleanData(addressField3)
        let description = descriptionText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let user = Auth.auth().currentUser, let username = user.displayName else {
            return
        }
        
        let eventDict = [
            "name": eventName,
            "description": description,
            "location": location,
            "date_start": date_start,
            "date_end": date_end,
            "address1": address1,
            "address2": address2,
            "address3": address3,
            "username": username
        ]
        
        self.eventService.createEvent(dictionary: eventDict, uuid: self.uuid)
        
        self.transitionToHome()
        //some sort of validation - all fields filled out, doesn't currently exist, etc
        // logic, if not filled in throw error
    }
    
    func transitionToHome() {
        
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController)
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }
    
}

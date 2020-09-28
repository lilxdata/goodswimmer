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
    @IBOutlet weak var timeField1: UITextField!
    @IBOutlet weak var timeField2: UITextField!
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
        
        let textfields = [titleField, locationField, dateField1, dateField2, timeField1, timeField2]
        
        for textfield in textfields {
            Utilities.styleTextField(textfield!, size: fieldSize)
        }
        
        //TODO: add disabled option in helper func for styleTextField
        
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
        var eventNameInput = Utilities.cleanData(titleField)
        var locationInput = Utilities.cleanData(locationField)
        var date_start_input = Utilities.cleanData(dateField1)
        var start_time_input = Utilities.cleanData(dateField2)
        var address1Input = Utilities.cleanData(addressField1)
        var address2Input = Utilities.cleanData(addressField2)
        var address3Input = Utilities.cleanData(addressField3)
        let description = descriptionText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
         
        //Event Name Validation
        let eventNameValid = Validators.isNameValid(eventNameInput)
        if !eventNameValid {
            eventNameInput = "Invalid Event Name, please reenter"
        }
        let eventName = eventNameInput
         
        //Location Validation
        let locationValid = Validators.isCityValid(locationInput)
        if !locationValid {
            locationInput = "Invalid Location, please reenter"
        }
        let location = locationInput
         
        //Date Start Validation
        let date_start_valid = Validators.isDateValid(date_start_input)
        if !date_start_valid {
            date_start_input = "Invalid Date, please reenter"
        }
        let date_start = date_start_input
         
        //Start Time Validation
        let start_time_valid = Validators.isTimeValid(start_time_input)
        if !start_time_valid {
            start_time_input = "Invalid Time, please reenter"
        }
        let start_time = start_time_input
         
        //Street/Number Validation
        let address1Valid = Validators.isStreetNumberValid(address1Input)
        if !address1Valid {
            address1Input = "Invalid Street/Number, please reenter"
        }
        let address1 = address1Input
         
        //City,State Validation
        let address2Valid = Validators.isCityStateValid(address2Input)
        if !address2Valid {
            address2Input = "Invalid City,State, please reenter"
        }
        let address2 = address2Input
        
        //Zip Code Validation
        let address3Valid = Validators.isZipCodeValid(address3Input)
        if !address3Valid {
            address3Input = "Invalid Zip Code, please reenter"
        }
        let address3 = address3Input
        
        guard let user = Auth.auth().currentUser, let username = user.displayName else {
            print("user not logged in / username not found")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy hh:mma"
        let dateTimeString = date_start + " " + start_time
        print("dt string", dateTimeString)
        guard let startDate = dateFormatter.date(from: dateTimeString) else {
            print("something wrong with date")
            return
        }
        
        let eventDict = [
            "name": eventName,
            "description": description,
            "location": location,
            "start_date": Timestamp.init(date: startDate),
           // TODO: change this date_end name to "time" and add date_end and time_end fields
            "address1": address1,
            "address2": address2,
            "address3": address3,
            "username": username
            ] as [String : Any]
        
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

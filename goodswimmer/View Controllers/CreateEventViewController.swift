//
//  CreateEventViewController.swift
//  goodswimmer
//
//  Created by madi on 5/13/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let labelSize = 12
        let fieldSize = 15
        let headerSize = 35
        
        
        Utilities.styleLabel(titleLabel, size: labelSize, uppercase: true)
        Utilities.styleTextField(titleField, size: fieldSize)
        
        Utilities.styleLabel(locationLabel, size: labelSize, uppercase: true)
        Utilities.styleTextField(locationField, size: fieldSize)
    
        Utilities.styleLabel(dateLabel, size: labelSize, uppercase: true)
        Utilities.styleTextField(dateField1, size: fieldSize)
        Utilities.styleTextField(dateField2, size: fieldSize)
        
        Utilities.styleLabel(addressLabel, size: labelSize, uppercase: true)
        Utilities.styleDisabledTextField(addressField1,size: fieldSize)
        Utilities.styleDisabledTextField(addressField2, size: fieldSize)
        Utilities.styleDisabledTextField(addressField3, size: fieldSize)
        
        Utilities.styleLabel(descriptionLabel, size: labelSize, uppercase: true)
        
        Utilities.styleLabel(imageLabel, size: labelSize, uppercase: true)
        
        Utilities.styleButton(createEventButton)
        Utilities.styleLabel(createEventHeader, size: headerSize, uppercase: false)
        
        
        //TODO: disable address field until location field is filled out - make it some sort of state, once location is put in, check DB if it exists, if not enable address  field, then send noti to us to send postcard inviting them to join. if location does exist, populate with address
        
        //TODO: add red asterisks to mandatory categories; helper isMandatory or something
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func createEventTapped(_ sender: Any) {
        //write to DB
        //some sort of validation - all fields filled out, doesn't currently exist, etc
        //then transition to home screen
        //  do we want like a "success!" popup?
    }
    
    
    
}

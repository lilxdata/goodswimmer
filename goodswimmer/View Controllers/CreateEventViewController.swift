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
    
    @IBOutlet weak var locationField: UITextField!
    
    
    @IBOutlet weak var addressField1: UITextField!
    
    @IBOutlet weak var addressField2: UITextField!
    
    @IBOutlet weak var addressField3: UITextField!
    
    
    @IBOutlet weak var dateField1: UITextField!
    
    @IBOutlet weak var dateField2: UITextField!
    
    @IBOutlet weak var createEventButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //TODO: label & button & field styling
        
        Utilities.styleTextField(titleField)
        Utilities.styleTextField(locationField)
    
        Utilities.styleTextField(dateField1)
        Utilities.styleTextField(dateField2)
        
        Utilities.styleTextField(addressField1)
        Utilities.styleTextField(addressField2)
        Utilities.styleTextField(addressField3)
        Utilities.styleButton(createEventButton)
        Utilities.styleFormHeaders(createEventHeader)
        
        //TODO: disable address field until location field is filled out - make it some sort of state, once location is put in, check DB if it exists, if not enable address  field, then send noti to us to send postcard inviting them to join. if location does exist, populate with address
    }
    

    
    @IBAction func createEventTapped(_ sender: Any) {
        //write to DB
        //some sort of validation - all fields filled out, doesn't currently exist, etc
        //then transition to home screen
        //  do we want like a "success!" popup?
    }
    
}

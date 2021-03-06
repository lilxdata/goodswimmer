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
import FirebaseStorage
import SDWebImage

class CreateEventViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var createEventScrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var createEventHeader: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var participantsField: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressField1: UITextField!
    @IBOutlet weak var addressField2: UITextField!
    @IBOutlet weak var addressField3: UITextField!
    @IBOutlet weak var stateAbbreviation: UITextField!
    @IBOutlet weak var inviteToGSButton: UIButton!
    @IBOutlet weak var dateField1: UITextField!
    @IBOutlet weak var dateField2: UITextField!
    @IBOutlet weak var timeField1: UITextField!
    @IBOutlet weak var timeField2: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createEventButton: UIButton!
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var WheelchairAccessibleButton: UIButton!
    @IBOutlet weak var CloseToTransitButton: UIButton!
    @IBOutlet weak var accessibleRestroomButton: UIButton!
    @IBOutlet weak var NOTAFLOFButton: UIButton!
    @IBOutlet weak var scentFreeButton: UIButton!
    @IBOutlet weak var otherAccButton: UIButton!
    @IBOutlet weak var OtherAccessibilityText: UITextView!
    @IBOutlet weak var ticketPriceLabel: UILabel!
    @IBOutlet weak var ticketPriceField: UITextField!
    @IBOutlet weak var inviteOnlyButton: UIButton!
    //@IBOutlet weak var inviteOnlyField: UITextView!
    @IBOutlet weak var multidayEventButton: UIButton!
    
    //@IBOutlet weak var createItTestLabel: UILabel!
    
    @IBOutlet weak var virtualEventButton: UIButton!
    @IBOutlet weak var cancelMultiDate: UIButton!
    
    @IBOutlet weak var accessiblityTitleLabel: UILabel!
    
    var accessibilityArray = ["wheelchair" : false,  "transit" : false, "restroom" : false, "NOTAFLOF" : false, "scentFree" : false, "other" : false]
    var inviteToGSState = false
    var inviteOnlyState = false
    var multiDayEventState = false
    var virtualEventState = false
    let photoHelper = PhotoHelper()
    let eventService = EventService.sharedInstance
    var uuid = ""
    let menu = Menu.sharedInstance
    var stockImages = ["checked": UIImageView(image: UIImage(systemName: "square")),
                      "unchecked": UIImageView(image: UIImage(systemName: "square")),
                      "goodswimmer stock profile": UIImageView()
                      ]
    var stockURL = ""
    
    //runs everytime page is shown
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //generate unique id for each event
        uuid = UUID().uuidString
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadStockPhotos()
        var filename = "checked"
        //self.stockImages[filename]?.image = self.photoHelper.resizeImage(image: (self.stockImages[filename]?.image)!, newWidth: 200.0)

        // Do any additional setup after loading the view.
        
        let labelSize = 12
        let fieldSize = 15
        let headerSize = 35
        
        //label styling
        let labels = [titleLabel, participantsLabel, locationLabel,descriptionLabel, dateLabel, imageLabel, ticketPriceLabel, accessiblityTitleLabel]
        
        for label in labels {
            stackView.setCustomSpacing(16, after: label!)
            Utilities.styleLabel(label!, size: labelSize, uppercase: true)
        }
        
        let textfields = [titleField, locationField, dateField1, dateField2, timeField1, timeField2, addressField1, addressField2, addressField3, ticketPriceField, stateAbbreviation]
        
        for textfield in textfields {
            Utilities.styleTextField(textfield!, size: fieldSize)
        }
        addressField1.isUserInteractionEnabled = true
        addressField2.isUserInteractionEnabled = true
        addressField3.isUserInteractionEnabled = true
        stateAbbreviation.isUserInteractionEnabled = true
        //createItTestLabel.font = UIFont(name: "Standard-Book", size: 21)
        
        Utilities.styleButton(createEventButton)
        Utilities.styleLabel(createEventHeader, size: headerSize, uppercase: false)
        
        descriptionText.layer.borderColor = UIColor.black.cgColor
        descriptionText.layer.borderWidth = 1
        OtherAccessibilityText.layer.borderColor = UIColor.black.cgColor
        OtherAccessibilityText.layer.borderWidth = 1
        OtherAccessibilityText.isUserInteractionEnabled = false
        OtherAccessibilityText.isHidden = true
        Utilities.styleDisabledTextView(OtherAccessibilityText, size: fieldSize)
        participantsField.layer.borderColor = UIColor.black.cgColor
        participantsField.layer.borderWidth = 1
        participantsField.isUserInteractionEnabled = true

        /*
        inviteOnlyField.layer.borderColor = UIColor.black.cgColor
        inviteOnlyField.layer.borderWidth = 1
        inviteOnlyField.isUserInteractionEnabled = false
        */
        dateField2.isUserInteractionEnabled = false
        dateField2.isHidden = true
        cancelMultiDate.isHidden = true
        
        self.transitionToHome()
        
        //TODO: disable address field until location field is filled out - make it some sort of state, once location is put in, check DB if it exists, if not enable address  field, then send noti to us to send postcard inviting them to join. if location does exist, populate with address
        
        //TODO: add red asterisks to mandatory categories; helper isMandatory or something
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        print(Auth.auth().currentUser!.displayName!)
        photoHelper.completionHandler =  { image in
            self.eventService.uploadImage(for: image, id: self.uuid, name:Auth.auth().currentUser!.displayName!+Utilities.cleanData(self.titleField))
        }
        photoHelper.presentActionSheet(from: self)
    }
    
    @IBAction func createEventTapped(_ sender: Any) {
        var eventNameInput = Utilities.cleanData(titleField)
        var locationInput = Utilities.cleanData(locationField)
        var date_start_input = Utilities.cleanData(dateField1)
        var date_end_input = Utilities.cleanData(dateField2)
        var time_start_input = Utilities.cleanData(timeField1)
        var time_end_input = Utilities.cleanData(timeField2)
        var address1Input = Utilities.cleanData(addressField1)
        var address2Input = Utilities.cleanData(addressField2)
        var address3Input = Utilities.cleanData(addressField3)
        var stateAbbreviationInput = Utilities.cleanData(stateAbbreviation)
        
        let description = descriptionText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let participants = participantsField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //var inviteList = inviteOnlyField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(inviteOnlyState == false) {
            //inviteList = ""
        }
        
        let ticketPrice = Int(ticketPriceField.text!) ?? 0
     
        
        var errorMessage = ""
        
        //Event Name Validation
        let eventNameValid = Validators.isLocationValid(eventNameInput)
        if !eventNameValid {
            eventNameInput = "Invalid Event Name, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + eventNameInput
        }
        let eventName = eventNameInput
        
        //Location Validation
        let locationValid = Validators.isLocationValid(locationInput)
        if !locationValid {
            locationInput = "Invalid Location, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + locationInput
        }
        let location = locationInput
        
        //Date Start Validation
        print("date_start_input", date_start_input)
        let date_start_valid = Validators.isDateValid(date_start_input)
        if !date_start_valid {
            date_start_input = "Invalid Date, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + date_start_input
        }
        let date_start = date_start_input
        
        //Date End Validation
        print("date_end_input", date_end_input)
        let date_end_valid = Validators.isDateValid(date_end_input)
        if (!date_end_valid && (multiDayEventState == true)){
            date_end_input = "Invalid Date, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + date_end_input
        }
       
        if(multiDayEventState == false){
            date_end_input = date_start_input
        }
        
        let date_end = date_end_input

        
        //Start Time Validation
        let time_start_valid = Validators.isTimeValid(time_start_input)
        if !time_start_valid {
            time_start_input = "Invalid Time, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + time_start_input
        }
        let time_start = time_start_input
        
        //End Time Validation
        let time_end_valid = Validators.isTimeValid(time_end_input)
        if !time_end_valid {
            time_end_input = "Invalid Time, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + time_end_input

        }
        let time_end = time_end_input
        
        //Street/Number Validation
        let address1Valid = Validators.isStreetNumberValid(address1Input)
        if !address1Valid {
            address1Input = "Invalid Street/Number, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + address1Input
        }
        let address1 = address1Input
        
        //City,State Validation
        let address2Valid = Validators.isCityValid(address2Input)
        if !address2Valid {
            address2Input = "Invalid City, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + address2Input
        }
        let address2 = address2Input
        
        //Zip Code Validation
        let address3Valid = Validators.isZipCodeValid(address3Input)
        if !address3Valid {
            address3Input = "Invalid Zip Code, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + address3Input
            
        }
        let address3 = address3Input
        
        let stateAbbreviationValid = Validators.isStateValid(stateAbbreviationInput)
        if !stateAbbreviationValid {
            stateAbbreviationInput = "Invalid Zip Code, please reenter"
            errorMessage = errorMessage + "\n"
            errorMessage = errorMessage + stateAbbreviationInput
            
        }
        let stateAbbreviation = stateAbbreviationInput
        
        guard let user = Auth.auth().currentUser, let username = user.displayName else {
            print("user not logged in / username not found")
            return
        }
        
        if(errorMessage != ""){
            addErrorPopUp(_sender: self.view, errorMessageInput: errorMessage)
            return
        }
        //combine start time & date and end time & date fields into 2 timestamp objects
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
        let dateTimeString = date_start + " " + time_start
        print("start date time string", dateTimeString)
        let endDateTimeString = date_end + " " + time_end
        print("end date time string", endDateTimeString)
        guard let startDate = dateFormatter.date(from: dateTimeString), var endDate = dateFormatter.date(from: endDateTimeString) else {
            print("something wrong with date")
            return
        }        
        let accessibilityAs = [accessibilityArray["wheelchair"], accessibilityArray["transit"], accessibilityArray["restroom"], accessibilityArray["NOTAFLOF"], accessibilityArray["scentFree"], accessibilityArray["other"]]
        var otherDescription = OtherAccessibilityText.text
        if(accessibilityArray["other"] == false) {
            otherDescription = ""
        }

        let eventDict = [
            "name": eventName,
            "description": description,
            "location": location,
            "participants" : participants,
            "start_date": Timestamp.init(date: startDate),
            "end_date": Timestamp.init(date: endDate),
            // TODO: change this date_end name to "time" and add date_end and time_end fields
            "address" : address1+", "+address2+", "+stateAbbreviation+" "+address3,
            "street number": address1,
            "city": address2,
            "zip code": address3,
            "state" : stateAbbreviation,
            "username": username,
            "accessibilityAs": accessibilityAs,
            "otherDescription": otherDescription,
            "inviteList" : "",//inviteList,
            "ticketPrice" : ticketPrice,
            "inviteToGS" : inviteToGSState,
            "inviteOnly" : inviteOnlyState,
            "virtualEvent" : virtualEventState,
            "createdDate": NSDate(timeIntervalSince1970:(NSDate().timeIntervalSince1970)) ,
        ] as [String : Any]
        let db = Firestore.firestore()
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                    "events" : [eventName]
                ])
            } else {
                print("Error adding event")
            }
        }
        
        self.eventService.createEvent(dictionary: eventDict, uuid: self.uuid)
        
        self.transitionToHome()
    }
    
    func transitionToHome() {
        
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController)
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
        addSuccessPopUp(_sender: (tabViewController?.view)!)
    }
    
    func setupCheckBoxes() {
        print("I am setting up")
        let buttons = [inviteToGSButton, WheelchairAccessibleButton, CloseToTransitButton,
                       accessibleRestroomButton, NOTAFLOFButton, scentFreeButton, otherAccButton,
                       multidayEventButton, inviteOnlyButton, virtualEventButton]
        for button in buttons {
            setCheckMark(button: button!, check: false)
        }
        
    }
    
    func loadStockPhotos() {
        print("I am downloading")
        let filenames = ["checked", "unchecked", "goodswimmer stock profile"]
        for filename in filenames {
            let imageRef = Storage.storage().reference().child(filename+".png")
            // Fetch the download URL
            imageRef.downloadURL { url, error in
              if let error = error {
                // Handle any errors
                print("An error ocurred while getting stock photos:", error)
              } else {
                // Get the download URL
                self.stockImages[filename]?.sd_setImage(with: url, completed: { (_: UIImage?,_: Error?, _: SDImageCacheType, _: URL?) -> Void in
                    if filename == "unchecked" {
                        self.setupCheckBoxes()
                    }
                    if filename == "goodswimmer stock profile" {
                        
                        self.stockURL = url!.absoluteString
                        print(self.stockURL)
                    }
                })
              }
            }
        }
    }

    
    
    func setCheckMark(button: UIButton, check: Bool) {
        if(check) {
            button.setImage(stockImages["checked"]?.image, for: .normal)
        }
        else {
            button.setImage(stockImages["unchecked"]?.image, for: .normal)
        }
        
    }
    //Move this later
    func addErrorPopUp(_sender: UIView, errorMessageInput: String?) {
        let errorMessage = "An error occurred:\n" + errorMessageInput!
        let xPos = (_sender.frame.width)*0.1
        let yPos = (_sender.frame.height)*0.1
        let width = (_sender.frame.width)*0.8
        let height = (_sender.frame.height)*0.7
        let errorPopUp = UIView(frame: CGRect(x: xPos, y: yPos, width:width, height:height))
        errorPopUp.backgroundColor = UIColor.white
        errorPopUp.layer.borderColor = CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
        errorPopUp.layer.borderWidth = 1
        let errorMessageButton = UIButton(type: UIButton.ButtonType.system)
        errorMessageButton.frame = CGRect(x: 0, y: 0, width:width, height:height)
        errorMessageButton.addTarget(self.menu, action: #selector(self.menu.closeAddTolistMenu), for: .touchUpInside)
        errorMessageButton.setTitle("An error occurred", for: .normal)
        errorMessageButton.setTitleColor(UIColor.red, for: .normal)
        errorMessageButton.contentHorizontalAlignment = .center
        errorPopUp.addSubview(errorMessageButton)
        errorMessageButton.titleLabel?.numberOfLines = 100
        print(errorMessage)
        errorMessageButton.setTitle(errorMessage, for: .normal)
        _sender.addSubview(errorPopUp)
        
    }
    
    func addSuccessPopUp(_sender: UIView) {
        let xPos = (_sender.frame.width)*0.1
        let yPos = (_sender.frame.height)*0.1
        let width = (_sender.frame.width)*0.8
        let height = (_sender.frame.height)*0.7
        let successPopUp = UIView(frame: CGRect(x: xPos, y: yPos, width:width, height:height))
        successPopUp.backgroundColor = UIColor.white
        successPopUp.layer.borderColor = CGColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1)
        successPopUp.layer.borderWidth = 1
        let successMessageButton = UIButton(type: UIButton.ButtonType.system)
        successMessageButton.frame = CGRect(x: 0, y: 0, width:width, height:height)
        successMessageButton.addTarget(self.menu, action: #selector(self.menu.closeAddTolistMenu), for: .touchUpInside)
        successMessageButton.setTitle("Your event was created!", for: .normal)
        successMessageButton.setTitleColor(UIColor.green, for: .normal)
        successMessageButton.contentHorizontalAlignment = .center
        //successMessageButton.titleLabel?.
        successPopUp.addSubview(successMessageButton)
        successMessageButton.titleLabel?.numberOfLines = 100
        _sender.addSubview(successPopUp)
        print(_sender)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 1000
    }
    
    @IBAction func wheelchairAccessiblePressed(_ sender: Any) {
        accessibilityArray["wheelchair"] = !(accessibilityArray["wheelchair"] ?? true)
        setCheckMark(button: WheelchairAccessibleButton, check: accessibilityArray["wheelchair"] ?? false)
    }
    @IBAction func closeToTransitPressed(_ sender: Any) {
        accessibilityArray["transit"] = !(accessibilityArray["transit"] ?? true)
        setCheckMark(button: CloseToTransitButton, check: accessibilityArray["transit"] ?? false)
    }
   
    @IBAction func accessibleRestroomPressed(_ sender: Any) {
        accessibilityArray["restroom"] = !(accessibilityArray["restroom"] ?? true)
        setCheckMark(button: accessibleRestroomButton, check: accessibilityArray["restroom"] ?? false)
    }
    
    
    @IBAction func NOTAFLOFPressed(_ sender: Any) {
        accessibilityArray["NOTAFLOF"] = !(accessibilityArray["NOTAFLOF"] ?? true)
        setCheckMark(button: NOTAFLOFButton, check: accessibilityArray["NOTAFLOF"] ?? false)
    }
    @IBAction func scentFreePressed(_ sender: Any) {
        accessibilityArray["scentFree"] = !(accessibilityArray["scentFree"] ?? true)
        setCheckMark(button: scentFreeButton, check: accessibilityArray["scentFree"] ?? false)
    }
    
    @IBAction func otherAccPressed(_ sender: Any) {
        accessibilityArray["other"] = !(accessibilityArray["other"] ?? true)
        setCheckMark(button: otherAccButton, check: accessibilityArray["other"] ?? false)
        let fieldSize = 15
        if(accessibilityArray["other"] == true){
            OtherAccessibilityText.isUserInteractionEnabled = true
            OtherAccessibilityText.isHidden = false
            Utilities.styleDisabledTextView(OtherAccessibilityText, size: fieldSize)
        }
        else {
            OtherAccessibilityText.isUserInteractionEnabled = false
            OtherAccessibilityText.isHidden = true
            Utilities.styleTextView(OtherAccessibilityText, size: fieldSize)
        }

    }
    @IBAction func inviteToGSPressed(_ sender: Any) {
        print("I am being pressed")
        inviteToGSState = !inviteToGSState
        setCheckMark(button: inviteToGSButton, check: inviteToGSState)
    }
    
   
    @IBAction func inviteOnlyPressed(_ sender: Any) {
        inviteOnlyState = !inviteOnlyState
        setCheckMark(button: inviteOnlyButton, check: inviteOnlyState)
    }
    
    @IBAction func virtualEventPressed(_ sender: Any) {
        virtualEventState = !virtualEventState
        setCheckMark(button: virtualEventButton, check: virtualEventState)
    }
    
    
    func multiDayToggle() {
        //setCheckMark(button: multidayEventButton, check: multiDayEventState)
        self.multiDayEventState = !self.multiDayEventState
        if(multiDayEventState == true){
            dateField2.isUserInteractionEnabled = true
            dateField2.isHidden = false
            multidayEventButton.isHidden = true
            cancelMultiDate.isHidden = false
            
        }
        else {
            dateField2.isUserInteractionEnabled = false
            dateField2.isHidden = true
            multidayEventButton.isHidden = false
            cancelMultiDate.isHidden = true
        }
    }
    @IBAction func multiDayEventPressed(_ sender: Any) {
        multiDayToggle()
        print("I pressed the box")
    }

    @IBAction func multiDayEventCanceled(_ sender: Any) {
        multiDayToggle()
        print("I pressed cancel")
    }
}

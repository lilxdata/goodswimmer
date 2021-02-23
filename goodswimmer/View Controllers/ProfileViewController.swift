//
//  ProfileViewController.swift
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
import FSCalendar


class ProfileViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UICollectionViewDelegate,
                             UICollectionViewDataSource  {
    let eventService = EventService()
    //let userService = UserService()
    let photoHelper = PhotoHelper()
    //access to eventarray across app
    let eventArray = EventArray.sharedInstance
    var myEventsArr = [" "]
    var uuid = ""
    var state : UIControl.State = []
    
    
    // Get a reference to the storage service using the default Firebase App
    let storage = Storage.storage()

    // Create a storage reference from our storage service
    let storageRef = Storage.storage().reference()
    
    //Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var bioButton: UIButton!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var eventsHosting: UIButton!
    @IBOutlet weak var eventHostingDate: UIButton!
    @IBOutlet weak var eventHostingTitle: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    
    
    @IBAction func bioButtonTapped(_ sender: Any) {
        if(self.bioButton.currentTitle == "Update Bio!"){
            self.bioTextField.isHidden = false
            self.bioTextField.text = "Enter your new bio here!"
            self.bioButton.setTitle("Save changes?", for: state)
        }
        else{
            self.bioLabel.text = self.bioTextField.text
            let db = Firestore.firestore()
            db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["bio" : self.bioTextField.text!])
            self.bioTextField.text = ""
            self.bioTextField.isHidden = true
            self.bioButton.setTitle("Update Bio!", for: state)
        }
    }
    @IBAction func profileImageTapped(_ sender: Any) {
        photoHelper.completionHandler =  { image in
            //make unique identifier for image
            let photoid = Auth.auth().currentUser!.uid
            let imageRef = Storage.storage().reference().child(photoid+".jpg")
            let user = Auth.auth().currentUser
            let stockPhotoRef = Storage.storage().reference().child("goodswimmer stock profile.png")
            // Fetch the download URL
            stockPhotoRef.downloadURL { stock_url, error in
              if let error = error {
                // Handle any errors
                print("Error retreiving stock photo:",error)
              } else {
                //Removes image from storage
                if(stock_url != user?.photoURL){
                    imageRef.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            print("Removed old profile picture, adding uploaded image")
                        }
                    }
                }
                else {
                    print("Updating from stock photo")
                }
              }
            }
            StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
                let urlString = downloadURL.absoluteString
                print("image URL: \(urlString)")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = URL(string: urlString)
                self.profileImage.sd_setImage(with: user?.photoURL, for: self.state, completed: nil)
                changeRequest?.commitChanges { (error) in
                }
            }
        }
        photoHelper.presentActionSheet(from: self)
    }
         
    
    
    func setUpElements() {
        //Utilities.styleButton(bioButton)
        Utilities.styleLabel(bioLabel, size: 12, uppercase: true)
        bioLabel.numberOfLines = 5
        usernameLabel.text = Auth.auth().currentUser?.displayName
        usernameLabel.textAlignment = .center
        
        eventHostingDate.tintColor = .black
        eventHostingDate.titleLabel?.numberOfLines = 2
        
        eventHostingTitle.tintColor = .black
        eventHostingTitle.titleLabel?.numberOfLines = 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        let user = Auth.auth().currentUser
        print(user?.photoURL)
        profileImage.sd_setImage(with: user?.photoURL, for: state, completed: nil)
        profileImage.imageView?.makeRounded(_cornerRadius: profileImage.frame.height)
        self.bioTextField.isHidden = true
        let db = Firestore.firestore()
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                self.bioLabel.text = document.get("bio") as? String ?? "Error retreiving bio"
                self.myEventsArr = document.get("events") as! [String]
                self.calendar.reloadData()
            } else {
                print("Error retreiving bio")
            }
        }
        
        
        for event in eventArray.events {
            var eventDate =  NSDate() as Date
            if event.username == Auth.auth().currentUser?.displayName {
                if  (event.startDate?.dateValue())!  > eventDate {
                    eventDate = (event.startDate?.dateValue() as! NSDate) as Date
                    eventsHosting.sd_setImage(with: URL(string: event.photoURL!), for: state, completed: nil)
                    let formatter4 = DateFormatter()
                    formatter4.dateFormat = "HH:mm E, d MMM y"
                    var eventDateText = formatter4.string(from: (event.startDate?.dateValue())!) + "." + event.venue!
                    eventHostingDate.setTitle(eventDateText, for: .normal)
                    eventHostingTitle.setTitle(event.description, for: .normal)
                        
                }
            }
        }
        
        
        eventsHosting.layer.borderWidth = 10
        eventsHosting.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        calendar.scrollDirection = .vertical
        //calendar.appearance.borderDefaultColor = .black
        calendar.appearance.borderSelectionColor = .black
        calendar.appearance.selectionColor = .red
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 17.0)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 17.0)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 17.0)
        
        calendar.appearance.todayColor = .black
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.todaySelectionColor = .red
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        //eventsAttendingCV.delegate = self
        //eventsAttendingCV.dataSource = self
        
        
        signOutButton.setTitleColor(.red, for: .normal)
        signOutButton.layer.borderWidth = 2
        signOutButton.layer.borderColor = CGColor(red: 1.0, green: 0.3, blue: 0.0, alpha: 1.0)
    }
    
    //TODO: set user as not logged in...?
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("signed out")
            transitionToLogin()
        } catch let signOutError as NSError {
            print("error signing out", signOutError)
        }
    }
    
    func transitionToLogin() {
        
        let loginSB = UIStoryboard(name: "Login", bundle: nil)
        
        let loginViewController = loginSB.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController)
        
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     //   return selectedEvent?.attendees?.count ?? 0 //number of attendees
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let attendee = selectedEvent?.attendees?[indexPath.item]
        //guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myEventsCell", for: indexPath) as? myEventsCell else {
            return UICollectionViewCell()
        //}
        
        //cell.myEventsT
            //.attendeeToDisplay = attendee
        //return cell
        
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let dateString = formatter.string(from: date)
        print("Selected", dateString)
        print("Today's Events are: ")
        var eventsToday: [Event?] = []
        for event in eventArray.events{
            var eventDate = event.startDate?.dateValue()
            var eventDateString = formatter.string(from: eventDate!)
            if(eventDateString == dateString && self.myEventsArr.contains(event.name!)){
                print(event)
                eventsToday.append(event)
            }
        }
        //Go to
        //calendar_vc
        if let vc = storyboard?.instantiateViewController(withIdentifier: "calendar_vc") as? CalendarViewController {
            vc.eventsToday = eventsToday
            //vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    

    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        var eventCount = 0
        for event in eventArray.events{
            var eventDate = event.startDate?.dateValue()
            var eventDateString = self.dateFormatter2.string(from: eventDate!)
            if eventDateString.contains(dateString) && self.myEventsArr.contains(event.name!) {
                eventCount = eventCount + 1
            }
        }
        return 0
    }
    

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {

        //format date according your need

        let dateString = self.dateFormatter2.string(from: date)
        //your events date array
        var eventCount = 0
        for event in eventArray.events{
            var eventDate = event.startDate?.dateValue()
            var eventDateString = self.dateFormatter2.string(from: eventDate!)
            if eventDateString.contains(dateString) && self.myEventsArr.contains(event.name!) {
                eventCount = eventCount + 1
            }
        }
        if(eventCount == 0){
            return nil
        }
        
        else if(eventCount == 1){
            return UIColor.blue
        }
        else {
            return UIColor.green
        }

        return nil //add your color for default

    }
    
    
    func set_photo(button: UIButton, name: String) {
        let imageRef = Storage.storage().reference().child(name)
        // Fetch the download URL
        imageRef.downloadURL { [self] url, error in
          if let error = error {
            // Handle any errors
            print("Error retreiving stock photo:",error)
          } else {
            print("I am getting the sign out button")
            print(url)
            button.sd_setImage(with: url, for: state, completed: nil)
          }
        }
       
    }
    
    @IBAction func eventHostingTapped(_ sender: Any) {
        print("I am pressing")
    }
    

}



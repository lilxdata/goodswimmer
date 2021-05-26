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


class ProfileViewController: UIViewController, UICollectionViewDelegate,
                             UICollectionViewDataSource  {
    let eventService = EventService()
    //let userService = UserService()
    let photoHelper = PhotoHelper()
    //access to eventarray across app
    let eventArray = EventArray.sharedInstance
    var myEventsArr = [" "]
    var uuid = ""
    var state : UIControl.State = []
    var profileOwner = User(following: [], followers: [], events: [])
    let user = Auth.auth().currentUser
    var isCurUser = true
    
    var updateBioActive = false
    let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 414, height: 300))
    
    //Calendar Vars
    var firstDate: Date?
        var lastDate: Date?
        var datesRange: [Date]?
        fileprivate let gregorian = Calendar(identifier: .gregorian)
        fileprivate let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        let highlightedColorForRange = UIColor.init(red: 2/255, green: 138/255, blue: 75/238, alpha: 0.2)


    
    
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
   
   

    @IBOutlet weak var signOutButton: UIButton!
    

    @IBOutlet weak var updateBioButton: UIButton!
    
    @IBOutlet weak var followButton: UIButton!

    @IBOutlet weak var cancelBioUpdateButton: UIButton!
    
    @IBOutlet weak var calendarView: UIView!
    
    @IBAction func cancelUpdateBio(_ sender: Any) {
        self.updateBioActive = false
        self.bioTextField.text = ""
        self.bioTextField.isHidden = true
        self.bioLabel.isHidden = false
        cancelBioUpdateButton.isHidden = true
        
    }
    
    
    @IBAction func bioButtonTapped(_ sender: Any) {
        if(updateBioActive == false){
            self.bioTextField.isHidden = false
            self.bioTextField.text = "Enter your new bio here!"
            self.updateBioActive = true
            self.bioLabel.isHidden = true
            cancelBioUpdateButton.isHidden = false
        }
        else{
            self.bioLabel.text = self.bioTextField.text
            let db = Firestore.firestore()
            db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["bio" : self.bioTextField.text!])
            self.bioTextField.text = ""
            self.bioTextField.isHidden = true
            self.bioLabel.isHidden = false
            self.updateBioActive = false
            cancelBioUpdateButton.isHidden = true
        }
    }
    @IBAction func profileImageTapped(_ sender: Any) {

        if(self.profileOwner.userId == self.user?.uid){
        photoHelper.completionHandler =  { image in
            //make unique identifier for image
            let photoid = Auth.auth().currentUser!.uid
            let imageRef = Storage.storage().reference().child(photoid+".jpg")
            Storage.storage().reference().child(photoid + ".jpg").delete {_ in }
            StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
                let db = Firestore.firestore()
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["photoURL" : downloadURL.absoluteString])
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = URL(string: downloadURL.absoluteString)
                self.profileImage.sd_setImage(with: downloadURL, for: self.state, completed: {_,_,_,_ in
                    var image = self.profileImage.image(for: .normal)?.roundedImage
                    image = self.resizeAsCircleImage(image: image! , newRadius: CGFloat(35/2))
                    self.tabBarController?.tabBar.items?[1].image = image
                    self.tabBarController?.tabBar.items?[1].image = self.tabBarController?.tabBar.items?[1].image!.withRenderingMode(.alwaysOriginal)
                    self.tabBarController?.tabBar.items?[1].selectedImage = self.tabBarController?.tabBar.items?[1].image!.withRenderingMode(.alwaysOriginal)
                })
              changeRequest?.commitChanges { (error) in
                }    
            }
        }
        photoHelper.presentActionSheet(from: self)
        }
    }
         
    func resizeAsCircleImage(image: UIImage, newRadius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: newRadius*2, height: newRadius*2))
        image.draw(in: CGRect(x: 0, y: 0, width: newRadius*2, height: newRadius*2))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func constraintsBuilder(item: Any, superview: Any, leading: Int, top: Int, height: Int, width: Int, centerX: Bool, centerY: Bool){
        let iPhoneH = view.fs_height
        let iPhoneW = view.fs_width
       
        let frameH = CGFloat(1/iPhoneH)
        let frameW = CGFloat(1/iPhoneW)

        var leadingEdgeConstraint: NSLayoutConstraint
        var topSpaceConstraint: NSLayoutConstraint
        var hConstraint: NSLayoutConstraint
        var wConstraint: NSLayoutConstraint
        var centerXConstraint: NSLayoutConstraint
        var centerYConstraint: NSLayoutConstraint

        if leading > 0 {
            leadingEdgeConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: CGFloat(leading))
            view.addConstraint(leadingEdgeConstraint)
        }
        if top > 0 {
            topSpaceConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: CGFloat(top))
            view.addConstraint(topSpaceConstraint)
        }
        
        if height > 0 {
            hConstraint = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: frameH, constant: CGFloat(height))
            view.addConstraint(hConstraint)
        }
        if width > 0 {
            wConstraint = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: frameW, constant: CGFloat(width))
            view.addConstraint(wConstraint)
        }
        if centerX {
            centerXConstraint = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 1)
            view.addConstraint(centerXConstraint)
        }
        if centerY {
            centerYConstraint = NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 1)
            view.addConstraint(centerYConstraint)
        }
    }
    
    func updateViewController(curUser: Bool){
        let containerView = profileImage.superview!
        profileImage.removeConstraints(profileImage.constraints)
        
        containerView.removeConstraints(containerView.constraints)
        bioButton.addTarget(self, action:#selector(bioButtonTapped), for: .touchUpInside)
            constraintsBuilder(item: profileImage!, superview: containerView, leading: -1, top: 31, height: 200, width: 200, centerX: true, centerY: false)
            constraintsBuilder(item: bioLabel!, superview: containerView, leading: -1, top: 262, height: 39, width: 216, centerX: true, centerY: false)
            constraintsBuilder(item: bioTextField!, superview: containerView, leading: -1, top: 262, height: 39, width: 216, centerX: true, centerY: false)
            constraintsBuilder(item: containerView, superview: containerView.superview as Any, leading: -1, top: -1, height: 295, width: -1, centerX: true, centerY: false)
            constraintsBuilder(item: containerView.superview!, superview: view!, leading: -1, top: -1, height: -1, width: -1, centerX: true, centerY: false)
        //}
    }
    
    
    func setUpElements() {
        Utilities.styleLabel(bioLabel, size: 15, uppercase: false)
        bioLabel.numberOfLines = 5
        
        usernameLabel.text = profileOwner.username
        usernameLabel.textAlignment = .center
        

        Utilities.styleLabel(followButton.titleLabel!, size: 15, uppercase: true)
        followButton.setTitle("FOLLOW", for: .normal)
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = Utilities.getRedCG()
        followButton.setTitleColor(Utilities.getRedUI(), for: .normal)
        
        cancelBioUpdateButton.isHidden = true
        
        if(isCurUser){
            Utilities.styleLabel(signOutButton.titleLabel!, size: 15, uppercase: true)
            signOutButton.setTitleColor(Utilities.getRedUI(), for: .normal)
            signOutButton.layer.borderWidth = 2
            signOutButton.layer.borderColor = Utilities.getRedCG()
            signOutButton.titleLabel?.textAlignment = .center
            signOutButton.isHidden = false

            set_photo(button: updateBioButton, name: "change_bio_button.png")
            updateBioButton.isHidden = false
            bioLabel.textAlignment = .left
            followButton.isHidden = true
        }
        else{
            signOutButton.isHidden = true

            updateBioButton.isHidden = true
            bioLabel.textAlignment = .center
            followButton.isHidden = false
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewController(curUser: self.isCurUser)
        calendarView.addSubview(calendar)
        //constraintsBuilder(item: calendar, superview: calendarView!, leading: 0, top: 0, height: Int(calendarView.fs_height), width: Int(calendarView.fs_width), centerX: false, centerY: false)
        formatCalendar(calendar: calendar, profile_vc: self)


        
        

        self.bioTextField.isHidden = true
        let db = Firestore.firestore()
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                var photoURL = URL(string: self.profileOwner.photoURL ?? Constants.Placeholders.placeholderURL)
                if(self.isCurUser){
                self.myEventsArr = document.get("events") as! [String]
                
                self.profileOwner.bio = document.get("bio") as? String
                self.profileOwner.events = document.get("events") as! [String]
                self.profileOwner.followers = document.get("followers") as! [String]
                self.profileOwner.following = document.get("following") as! [String]
                self.profileOwner.photoURL = document.get("photoURL") as! String
                self.profileOwner.userId = document.get("userId") as! String
                self.profileOwner.username = document.get("username") as! String
                photoURL = URL(string: document.get("photoURL") as! String)
                }
                self.profileImage.sd_setImage(with: photoURL, for: self.state, completed:
                    {_,_,_,_ in
                        self.profileImage.imageView?.makeRounded(_cornerRadius: self.profileImage.frame.height)

                        self.calendar.reloadData()
                        self.bioLabel.text = self.profileOwner.bio
                    })
                self.setUpElements()
            } else {
                print("Error retreiving bio")
            }
        }
        
        

        
        

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
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    func set_photo(button: UIButton, name: String) {
        let imageRef = Storage.storage().reference().child(name)
        // Fetch the download URL
        imageRef.downloadURL { [self] url, error in
          if let error = error {
            // Handle any errors
            print("Error retreiving stock photo:",error)
          } else {
            button.sd_setImage(with: url, for: state, completed: nil)
          }
        }
       
    }

    @IBAction func eventHostingTapped(_ sender: Any) {
        print("I am pressing")
    }
    
    
    @IBAction func followPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let curUser = db.collection("users").document(Auth.auth().currentUser!.uid)
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                db.collection("users").document(self.profileOwner.userId ?? "").updateData([
                    "followers" : FieldValue.arrayUnion([Auth.auth().currentUser!.displayName!])
                ])      
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                    "following" : FieldValue.arrayUnion([self.profileOwner.username!])
                ])
            } else {
                print("Error following user")
            }
        }
    }
}

extension ProfileViewController {

    func configureVisibleCells() {
        self.calendar.visibleCells().forEach { (cell) in
            let date = self.calendar.date(for: cell)
            let position = self.calendar.monthPosition(for: cell)
            self.configureCell(cell, for: date, at: position)
        }
    }

    func configureCell(_ cell: FSCalendarCell?, for date: Date?, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        
        diyCell.selectionLayer.fillColor = UIColor.white.cgColor
        // Configure selection layer
        diyCell.selectionLayer.isHidden = false
        diyCell.selectionType = .middle
        if calendar.selectedDates.contains(date!) {
            diyCell.selectionLayer.fillColor = Utilities.getRedCG()
        }
        // original code https://stackoverflow.com/questions/58424445/how-to-customise-cell-in-fscalendar
    }

    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }

}

extension ProfileViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
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
            self.calendar.reloadData()
            //vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
        
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            print("datesRange contains: \(datesRange!)")
             configureVisibleCells()
            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]

                print("datesRange contains: \(datesRange!)")
                configureVisibleCells()
                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range

            print("datesRange contains: \(datesRange!)")
            configureVisibleCells()
            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains: \(datesRange!)")
        }
        configureVisibleCells()
    }


    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureCell(cell, for: date, at: monthPosition)
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == FSCalendarMonthPosition.current
    }

    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did deselect date \(self.formatter.string(from: date))")
        configureVisibleCells()
    }
    
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        var eventCount = 0
        for event in eventArray.events{
            let eventDate = event.startDate?.dateValue()
            let eventDateString = self.dateFormatter2.string(from: eventDate!)
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

}

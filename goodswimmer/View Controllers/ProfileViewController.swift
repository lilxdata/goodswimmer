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


//https://firebasestorage.googleapis.com/v0/b/good-swimmer.appspot.com/o/test_image.jpg?alt=media&token=7ab711db-332a-4cf1-a4b3-bb711b0def0c

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIButton!
    @IBAction func profileImageTapped(_ sender: Any) {
        photoHelper.completionHandler =  { image in
            self.eventService.uploadImage(for: image, id: self.uuid)
        }
        photoHelper.presentActionSheet(from: self)
    }
    
    let eventService = EventService.sharedInstance
    let photoHelper = PhotoHelper()
    var uuid = ""
    var state : UIControl.State = []
    // Get a reference to the storage service using the default Firebase App
    let storage = Storage.storage()

    // Create a storage reference from our storage service
    let storageRef = Storage.storage().reference()
    //let eventArray = EventArray.sharedInstance
    
       

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a child reference
        // imagesRef now points to "images"
        let imagesRef = storageRef.child("images")

        // Child references can also take paths delimited by '/'
        // spaceRef now points to "images/space.jpg"
        // imagesRef still points to "images"
        var profRef = storageRef.child("goodswimmer stock profile.jpg")

        print(profRef)

        
        let imageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/good-swimmer.appspot.com/o/goodswimmer%20stock%20profile.png?alt=media&token=ca665fa0-9b4e-491d-bdfd-4195752d4dea")
        profileImage.sd_setImage(with: imageURL, for: state, completed: nil)
        let db = Firestore.firestore()
        //var users = db.collection("users")
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
       

        //print("I am doing stuff")
        /*db.collection("events").order(by: "start_date").addSnapshotListener { (querySnapshot, error) in
            if error == nil && querySnapshot != nil {
                //clear event array to remove dupes
                self.eventArray.events.removeAll()
                for document in querySnapshot!.documents {
                    print("document received")
                    let eventData = document.data()
                    if let event = Event(eventDict: eventData) {
                        print("I am pulling from firebase?")
                        self.eventArray.events.append(event)
                    }
                    
                }
            }
        }*/
        print("I am rounding the image")
        //image!.makeRounded()
        // Do any additional setup after loading the view.
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
    
    
}

extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

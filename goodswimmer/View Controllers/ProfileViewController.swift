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


class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIButton!
    @IBAction func profileImageTapped(_ sender: Any) {
        
        photoHelper.completionHandler =  { image in
            //make unique identifier for image
            let photoid = UUID().uuidString
            let imageRef = Storage.storage().reference().child(photoid+".jpg")
            StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
                let urlString = downloadURL.absoluteString
                print("image URL: \(urlString)")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = URL(string: urlString)
                changeRequest?.commitChanges { (error) in
                }
            }
        }
        photoHelper.presentActionSheet(from: self)
        let user = Auth.auth().currentUser
        profileImage.sd_setImage(with: user?.photoURL, for: state, completed: nil)
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
        let user = Auth.auth().currentUser
        profileImage.sd_setImage(with: user?.photoURL, for: state, completed: nil)
        profileImage.imageView?.makeRounded()
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

        self.layer.borderWidth = 3
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        print("I am printing height")
        print(self.frame.height)
        self.layer.cornerRadius = 40.0 //self.frame.height / 1
        self.clipsToBounds = true
    }
}

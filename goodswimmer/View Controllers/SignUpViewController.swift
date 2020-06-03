//
//  SignUpViewController.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class SignUpViewController: UIViewController {
 
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var signUpNextButton: UIButton!
    @IBOutlet weak var signUpBackButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    // TO DO: extract method
    func setUpElements() {
        //hide error label
        
        errorLabel.alpha = 0
        let fontSize = 15
        
        /* style elements */
        
        //style text fields using utilities helper
        Utilities.styleTextField(userNameField, size: fontSize)
        Utilities.styleTextField(emailField, size: fontSize)
        Utilities.styleTextField(passwordField, size: fontSize)
        Utilities.styleTextField(locationField, size: fontSize)
        
    }
    
    //Check fields and validate that data is correct
    //If all good, return nil
    // Otherwise, return error message
    
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        //trimmingCharacters gets rid of all newlines & whitespace
        if userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ==  "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ==  "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ==  ""  || locationField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Oops! You didn't \n fill everything in!"
        }
        //Check that pw is secure
        let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let secure = Utilities.isPasswordValid(cleanedPassword)
        
        if !secure {
            return "Let's make that \n password more secure!"
        }
        //Check that email is an email format (with @ etc)
        
        return nil //all good
    }

    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        
        
    }
    //handle sign up button tap
    @IBAction func signUpTapped(_ sender: Any) {
        //Validate fields
        
        let error = validateFields()
        if error != nil{
            //show error message
            showError(error!)
        }
        else {
            
            //Create cleaned version of data (strip whitespace & newlines)
            let username = userNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password  = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let location = locationField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for errors
                if err != nil {
                    self.showError("Error creating user")
                } else {
                    //User created
                    //Store info
                    let db = Firestore.firestore()
                    // Add a new document with a generated ID
                   db.collection("users").addDocument(data: [
                        "username": username,
                        "email": email,
                        "location": location,
                        "uid": result!.user.uid
                    ]) { err in
                        if  err != nil {
                            self.showError("Whoops! Something went wrong. \n Our bad. Try again?")
                        }
                    }
                }
            }
            
            //Transition to home screen
            self.transitionToHome()
        }
    }
    
    func showError(_ message:String)  {
        errorLabel.text! = message
        errorLabel.alpha = 1
        Utilities.styleError(errorLabel)
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController)  as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    

}

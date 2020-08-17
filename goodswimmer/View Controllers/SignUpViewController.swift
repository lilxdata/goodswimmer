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
        let usernameValid = Validators.isUsernameValid(userNameField.text!)
        
        if !usernameValid {
            return "Let's double check that \n username!"
        }
        //Check that email is an email format (with @ etc)
        let emailValid = Validators.isEmailValid(emailField.text!)
        
        if !emailValid {
            return "Let's double check that \n email!"
        }
        
        //Check that city is an city format (with @ etc)
        let cityValid = Validators.isCityValid(locationField.text!)
        
        if !cityValid {
            return "Let's double check that \n city!"
        }
        
        return nil //all good
        
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
     //TODO
        
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
                    //can also use CR for profile pic
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    
                    //TODO: set email and prof pic etc
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges { ( error ) in
                        if error != nil {
                            self.showError("Error")
                            self.deleteUser()
                            return
                        }
                        self.transitionToHome()
                    }
                }
            }
        }
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let _ = error {
                self.deleteUserAgain()
            }
        }
    }
    
    func deleteUserAgain() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let _ = error {
                do {
                    try Auth.auth().signOut()
                } catch {
                    self.showError("error")
                }
            }
        }
    }
    
    func showError(_ message:String)  {
        errorLabel.text! = message
        errorLabel.alpha = 1
        Utilities.styleError(errorLabel)
    }
    
    func transitionToHome() {
        guard let tabVC = Navigation.sharedInstance.goHome() else {
            return
        }
        present(tabVC, animated: true)
    }
}

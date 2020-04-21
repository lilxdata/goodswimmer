//
//  LoginViewController.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    

    func setUpElements() {
        //hide error label
        
        errorLabel.alpha = 0
        
        /* style elements */
        
        //style text fields using utilities helper
        Utilities.styleTextFieldRed(emailField)
        Utilities.styleTextFieldRed(passwordField)
        
        // style button
        Utilities.styleButton(signInButton)
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        //TODO: Validate text fields are filled in
        
        //Create clean versions of text fields
        
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pw = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Sign in
        
        Auth.auth().signIn(withEmail: email, password: pw) { (result, error) in
            if error != nil {
                self.errorLabel.text = "Whoops! Try that again."
                self.errorLabel.numberOfLines = 0
                self.errorLabel.alpha = 1
            }
            
                //TODO: extract method
            else {
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController)  as? HomeViewController
                     
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
}

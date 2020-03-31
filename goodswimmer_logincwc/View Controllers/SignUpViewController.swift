//
//  SignUpViewController.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
 
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    @IBOutlet weak var SignUpNextButton: UIButton!
    
    @IBOutlet weak var signUpHeaderLabel: UILabel!
    
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
        Utilities.styleTextField(nameField)
        Utilities.styleTextField(userNameField)
        Utilities.styleTextField(emailField)
        Utilities.styleTextField(PasswordField)
        
        // style button 
        Utilities.styleButton(SignUpNextButton)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //handle sign up button tap
    @IBAction func signUpTapped(_ sender: Any) {
    }
}

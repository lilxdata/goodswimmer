//
//  ViewController.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var descSubHeader: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }

    func setUpElements() {
        Utilities.styleHeader(titleHeader)
        Utilities.styleSubHeader(descSubHeader)
        Utilities.styleButton(signUpButton)
        Utilities.styleButton(signInButton)
    }
}


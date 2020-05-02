//
//  SetInterestsViewController.swift
//  goodswimmer
//
//  Created by madi on 4/28/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class SetInterestsViewController: UIViewController {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var subHeader: UILabel!
    
    @IBOutlet weak var visArtButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Utilities.styleHeader(header)
        Utilities.styleSubHeader(subHeader)
    }
    
    @IBAction func boxChecked(_ sender: Any) {
        //make box red
        Utilities.styleBoxChecked(visArtButton)
        
        //send info to DB
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

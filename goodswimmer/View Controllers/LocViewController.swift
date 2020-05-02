//
//  LocViewController.swift
//  goodswimmer
//
//  Created by madi on 4/28/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class LocViewController: UIViewController {

    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var subHeader: UILabel!
    @IBOutlet weak var locField: UITextField!
    @IBOutlet weak var locLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Utilities.styleTextField(locField)
        Utilities.styleHeader(header)
        Utilities.styleSubHeader(subHeader)
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

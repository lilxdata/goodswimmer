//
//  DetailViewController.swift
//  goodswimmer
//
//  Created by madi on 5/6/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    var selectedEvent: Event?
    var selectedImage: String?
    var selectedTitle: String?
    var placeholderURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

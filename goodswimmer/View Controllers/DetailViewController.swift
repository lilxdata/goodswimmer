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

//        if let event = selectedEvent {
//           // imageView.image =
//            placeholderURL = "www.goodswimmer.com"
//        //    event.name = eventTitle.text
//
//            let imageURL = URL(string: (selectedEvent?.photoURL ?? placeholderURL)!)
//            eventImage.sd_setImage(with: imageURL, completed: nil)
//
//        }
        // Do any additional setup after loading the view.
    }
    
    //display stuff
    //read from DB
    //how to find out which cell was clicked?... -> doing this in homeVC 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

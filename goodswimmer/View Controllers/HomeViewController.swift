//
//  HomeViewController.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()

       // read single document
        db.collection("events").document("event2").getDocument { (docSnapshot, error) in
            if error == nil && docSnapshot != nil && docSnapshot!.data() != nil {
                //display document
                
            }
        }
        
        //read collection of documents
        db.collection("events").getDocuments { (querySnapshot, error) in
            if error == nil && querySnapshot != nil {
                for document in querySnapshot!.documents {
                    // display data
                }
            }
        }
        
        
        
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

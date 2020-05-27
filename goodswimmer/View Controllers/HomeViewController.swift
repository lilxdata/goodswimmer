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
    //model var?
    
    @IBOutlet weak var GSLabel: UILabel!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        Utilities.styleAppName(GSLabel)
        
    }

}

extension HomeViewController: UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if events != nil {
                return events.count
            } else {
                displayZeroState()
            }
            
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if events != nil {
           // get event cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell

            //get event
            let event = events[indexPath.row]

            cell.displayEvent(event)
            return cell
        } else {
            zeroStateLabel.alpha = 1
        }

        
    }

    
}

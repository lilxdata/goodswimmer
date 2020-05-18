//
//  EventCell.swift
//  goodswimmer
//
//  Created by madi on 5/8/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var eventToDisplay:Event?
    
    func displayEvent(_ event:Event) {
        
        //clean up previous cell contents
        eventName.text=""
        
        
        //keep reference to event
        eventToDisplay = event
        eventName.text = eventToDisplay!.name
        
//           let db = Firestore.firestore()
//
//                //read collection of documents
//                db.collection("events").getDocuments { (querySnapshot, error) in
//                    if error == nil && querySnapshot != nil {
//                        for document in querySnapshot!.documents {
//                          //display event
//                            let nameIndex = document.data().index(forKey: "name")
//                            let name = document.data()[nameIndex!].value
//                            self.eventName.text = name as? String
//
//                        }
//                    }
//                }
//
        
        
        //set event title
        
      //  eventTitle.text = eventToDisplay!.name
        
        //download image
        
        
        
        //display image
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  EventCell.swift
//  goodswimmer
//
//  Created by madi on 5/8/20.
//  Copyright © 2020 madi. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {


    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    var eventToDisplay:Event?
    
    func displayEvent(_ event:Event) {
        //keep reference to event
        eventToDisplay = event
        
        //set event title
        
        eventTitle.text = eventToDisplay!.title
        
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

//
//  SpotCellController.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 2/17/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SpotCellController : UITableViewCell {
    var spot : Spot?
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBAction func cancel(sender: UIButton) {
        spot?.statusId = 4;
        spot?.toPFObject().saveInBackground()
        updateAllBid()
        self.backgroundColor = UIColor.lightGrayColor()
        cancelButton.enabled = false
        self.selectionStyle = .None
        self.userInteractionEnabled = false
    }
    
    
    func updateAllBid(){
        let query = PFQuery(className: "Bid")
        query.includeKey("user")
        query.includeKey("spot")
        query.whereKey("spot", equalTo: spot!.toPFObject())
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    
                    for object in objects {
                        object["StatusId"] = 5
                        object.saveInBackground()
                    }
                    
                }
            }
        }
    }
}

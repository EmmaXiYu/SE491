//
//  SpotCellController.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 2/17/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation
import UIKit

class SpotCellController : UITableViewCell {
    var spot : Spot?
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBAction func cancel(sender: UIButton) {
        spot?.statusId = 4;
        spot?.toPFObject().saveInBackground()
        self.backgroundColor = UIColor.lightGrayColor()
        cancelButton.enabled = false
        self.selectionStyle = .None
        self.userInteractionEnabled = false
    }
}
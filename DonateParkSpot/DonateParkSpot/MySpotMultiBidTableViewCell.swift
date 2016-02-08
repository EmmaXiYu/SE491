//
//  MySpotMultiBidTableViewCell.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 11/6/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class MySpotMultiBidTableViewCell: UITableViewCell {
    var bid : Bid = Bid()
    
    @IBOutlet weak var donation: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var bidder: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var reject: UIButton!
    
    @IBAction func acceptBid(sender: AnyObject) {
    }
    
    @IBAction func rejectBid(sender: AnyObject) {
    }
}

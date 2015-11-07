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


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
               
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func Accept_Clicked(sender: AnyObject) {
        
        
    }
    @IBAction func Reject_Clicked(sender: AnyObject) {
        
       var s = bid.value
        
    }
    @IBOutlet weak var lblTimr: UILabel!
    
    @IBOutlet weak var lblDonetion: UILabel!
    
    
}

//
//  MyBidTableViewCell.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 11/13/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class MyBidTableViewCell: UITableViewCell {
   var bid : Bid = Bid()
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblBidder: UILabel!
    @IBOutlet weak var lblDonetion: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code 
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state 
    }

}

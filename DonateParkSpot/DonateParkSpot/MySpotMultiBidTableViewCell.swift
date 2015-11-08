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

   /*
    
    func btnAccept_click(sender: UIButton!) {
        print("tapped button 1")
        var s = bid.value
         s = s! + 2
    }
    
    @IBAction func Reject_Clicked(sender: AnyObject) {
        print("tapped button 12")
      var s = bid.value
        s = s! + 2
        
    }
    */
    @IBOutlet weak var lblTimr: UILabel!
    
    @IBOutlet weak var lblDonetion: UILabel!
    
    @IBOutlet weak var lblBidder: UILabel!
    
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBOutlet weak var btnReject: UIButton!
    
}

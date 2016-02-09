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
    var table : MyBidTableViewController?
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDonetion: UILabel!
    @IBOutlet weak var btnCancel: UIButton!

    @IBAction func cancel(sender: AnyObject) {
        bid.statusId = 4
        bid.cancelByBidder = true
        let obj = bid.toPFObjet()
        obj.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView()
                    alert.title = "Success!"
                    alert.message = "Bid Canceled!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.table?.GetBidList()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView()
                    alert.title = "Error!"
                    alert.message = "Something went wrong!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.table?.GetBidList()
                })
            }
        }
    }
}

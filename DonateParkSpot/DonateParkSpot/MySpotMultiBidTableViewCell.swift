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
    var table : MySpotMultiBidTableViewController?
    
    @IBOutlet weak var donation: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var bidder: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var reject: UIButton!
    
    @IBAction func acceptBid(sender: AnyObject) {
        bid.bidAcceptTime = NSDate()
        bid.statusId = 2
        let object = bid.toPFObjet()
        object.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            if (success) {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView()
                    alert.title = "Success!"
                    alert.message = "Bid Accepted!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.table?.getBids()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView()
                    alert.title = "Error!"
                    alert.message = "Something went wrong!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.table?.getBids()
                })
            }
        }
    }
    
    @IBAction func rejectBid(sender: AnyObject) {
        bid.statusId = 4
        let object = bid.toPFObjet()
        object.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            if (success) {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView()
                    alert.title = "Success!"
                    alert.message = "Bid Rejected!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.table?.getBids()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView()
                    alert.title = "Error!"
                    alert.message = "Something went wrong!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.table?.getBids()
                })
            }
        }
    }
}

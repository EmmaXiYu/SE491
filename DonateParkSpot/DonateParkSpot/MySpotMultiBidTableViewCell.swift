//
//  MySpotMultiBidTableViewCell.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 11/6/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse

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
                
                
                /*Pravangsu 02202016 Start*/
                //Need to update the spot status as bid accepted . So that once the bid is accepted , action can be taken based on that.
                // For example, not show accepted bid in the map
                 let spot = object["spot"] as! PFObject
                 self.updateSpot(spot,status : 2)
                // The bid is accepted . Update the spot status 
                  /*Pravangsu 02202016 End*/
                
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView()
                    alert.title = "Success!"
                    alert.message = "Bid Accepted!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.table?.getBids()
                })
                
                /*let pushQuery = PFInstallation.query()
                pushQuery!.whereKey("SpotBidder", equalTo: object["user"] as! PFUser)
                let ifCancelledByBidder = object["CancelByBidder"] as! Bool
                if ifCancelledByBidder  != true {
                    let data = [
                        "alert" : "You bid is accepted. Go and pay for it." ,
                        "badge" : "Increment",
                        "sound" : "iphonenoti_cRjTITC7.mp3",]
                    // Send push notification to query
                   // let push = PFPush()
                  //  push.setQuery(pushQuery) // Set our Installation query
                   // push.setData(data)
                   // push.sendPushInBackground()
                }*/
            
            
            }
                else {
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
    
    func updateSpot(prefObjSpot : PFObject, status : Int)-> Void
    {
        
        prefObjSpot["StatusId"] = status
        prefObjSpot.saveInBackground()
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

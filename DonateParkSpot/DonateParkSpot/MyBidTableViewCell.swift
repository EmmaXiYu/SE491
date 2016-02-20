//
//  MyBidTableViewCell.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 11/13/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse


class MyBidTableViewCell: UITableViewCell {
    var bid : Bid = Bid()
    var table : MyBidTableViewController?
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDonetion: UILabel!
    @IBOutlet weak var btnCancel: UIButton!

    
    func updateSpot(prefObjSpot : PFObject, status : Int)-> Void
    {
      
                prefObjSpot["StatusId"] = status
                prefObjSpot.saveInBackground()
    }
    
    
    
    @IBAction func cancel(sender: AnyObject) {
        var bidOriginalStatus = bid.statusId
        bid.statusId = 4
        bid.cancelByBidder = true
        
        let obj = bid.toPFObjet()
        let spot = obj["spot"] as! PFObject
        obj.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                /*Pravangsu 02202016 Start*/
                self.updateSpot(spot,status : 1)
                // The bid is cancelld by bidder. Now should be open for Biding again
                /*Pravangsu 02202016 End*/
                
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView()
                    alert.title = "Success!"
                    alert.message = "Bid Canceled!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.table?.GetBidList()
                })
                let pushQuery = PFInstallation.query()
                pushQuery!.whereKey("SpotOwner", equalTo: spot["owner"] as! PFUser)
                if bidOriginalStatus == 2{
                let data = [
                    "alert" : "One accepted bid cancelled. Please choose other bid." ,
                    "badge" : "Increment",
                    "sound" : "iphonenoti_cRjTITC7.mp3",]
                    // Send push notification to query
                    let push = PFPush()
                    push.setQuery(pushQuery) // Set our Installation query
                    push.setData(data)
                    push.sendPushInBackground()}
                
                /*
                if bidOriginalStatus == 4{
                    let data = [
                        "alert" : "One rejected bid cancelled." ,
                        "badge" : "Increment",
                        "sound" : "iphonenoti_cRjTITC7.mp3",]
                    // Send push notification to query
                    let push = PFPush()
                    push.setQuery(pushQuery) // Set our Installation query
                    push.setData(data)
                    push.sendPushInBackground()}
                
                if bidOriginalStatus == 0{
                let data = [
                "alert" : "One bid cancelled." ,
                "badge" : "Increment",
                "sound" : "iphonenoti_cRjTITC7.mp3",]
                // Send push notification to query
                let push = PFPush()
                push.setQuery(pushQuery) // Set our Installation query
                push.setData(data)
                push.sendPushInBackground()}
                    */
                
                
                    
                
               

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

//
//  MyBidTableViewCell.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 11/13/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse
import UIKit

class MyBidTableViewCell: UITableViewCell {
    var bid : Bid = Bid()
    var table : MyBidTableViewController?
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDonetion: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
  //  @IBOutlet weak var btnReOpen: UIButton!
    
    func updateSpot(prefObjSpot : PFObject, status : Int)-> Void
    {
        
        prefObjSpot["StatusId"] = status
        prefObjSpot.saveInBackground()
    }
    
    /*
    @IBAction func btnReOpenClicked(sender: UIButton) {
        bid.statusId = 1
        bid.cancelByBidder = false
        let obj = bid.toPFObjet()
        obj.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.showmessage("Bid Reopened",msg : "Your Bid opend again.")
                self.table?.GetBidList()
            }
        }
    }
    */
    
    func showmessage(title : String, msg : String) ->Void
    {
        let alertController = UIAlertController(title: "Validation Error", message: msg, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
        }
        alertController.addAction(OKAction)
        self.parentViewController!.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    
    
    @IBAction func payment(sender: AnyObject) {
        
        
        self.table?.performSegueWithIdentifier("payment", sender: sender)
        
    }
    @IBAction func cancel(sender: AnyObject) {
        let bidOriginalStatus = bid.statusId
        bid.statusId = 4
        bid.cancelByBidder = true
        
        let obj = bid.toPFObjet()
        let spot = obj["spot"] as! PFObject
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
                /*
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
                    push.sendPushInBackground()}*/
                
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
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}
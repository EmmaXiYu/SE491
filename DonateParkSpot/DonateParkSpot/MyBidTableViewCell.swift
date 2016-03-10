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
    
    func showmessage(title : String, msg : String) ->Void
    {
        let alertController = UIAlertController(title: "Validation Error", message: msg, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
        }
        alertController.addAction(OKAction)
        self.parentViewController!.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    
    
    @IBOutlet weak var paymentButton: UIButton!
    @IBAction func payment(sender: AnyObject) {
        
        
        self.table?.performSegueWithIdentifier("payment", sender: sender)
        
    }
   func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!)
    {
        
        
        
        if (segue.identifier == "payment")
        {
            let paymentView = segue!.destinationViewController as! PaymentViewController
            paymentView.spotID = (self.bid.spot?.spotId)!
            
            
        }
        
        //let installation = PFInstallation.currentInstallation()
        //installation["SpotOwner"] = testObject["owner"] as! PFUser
        //installation.saveInBackground()
        
    }

    @IBAction func cancel(sender: AnyObject) {
        bid.statusId = 4
        
        
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
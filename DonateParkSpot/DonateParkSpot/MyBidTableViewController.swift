//
//  MyBidTableViewController.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 11/13/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse
class MyBidTableViewController: UITableViewController {
    
    
    var datas = [Bid] ()
    var ratingScore = [String:Double]()
    var ratingCount = [String:Int]()
    
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetBidList()
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        
    }
    
    func GetBidList()  {
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        
        query.includeKey("spot")
        query.includeKey("spot.owner")
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                self.datas.removeAll()
                for object in objects! {
                    let bi = Bid(object: object)
                    self.datas.append(bi!)
                }
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyBidCell", forIndexPath: indexPath) as!
        MyBidTableViewCell
        cell.bid =  datas[indexPath.row]
        let bid: Bid = datas[indexPath.row]
        cell.table = self
        cell.lblDonetion.text = String(bid.value!)
        cell.lblAddress.text = bid.spot?.addressText
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        if(bid.statusId != 2 )
        {
            
            cell.paymentButton.hidden = true
        }
        
        cell.btnCancel.enabled = true
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1)
        
        if (bid.statusId == 4 ) 
        {
            cell.btnCancel.enabled = false
            cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.10)
        }
       
        
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "payment" {
            let controller = segue.destinationViewController as? PaymentViewController
            let cell = sender!.superview!!.superview! as! MyBidTableViewCell
            controller?.spot = cell.bid.spot
            cell.bid.statusId = 3
            cell.bid.toPFObjet().saveInBackground()
            cell.bid.spot!.statusId = 3
            cell.bid.spot!.toPFObject().saveInBackground()
        }
    }
}

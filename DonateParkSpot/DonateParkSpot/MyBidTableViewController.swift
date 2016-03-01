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
        
        //cell.btnCancel.layer.borderWidth = 1
        //cell.btnReOpen.layer.borderWidth = 1
        //cell.btnCancel.layer.borderColor = UIColor.blueColor().CGColor
        //cell.btnReOpen.layer.borderColor = UIColor.blueColor().CGColor

        if(bid.cancelByBidder == nil)
        {
            bid.cancelByBidder = false
        }
        
        if (bid.cancelByBidder == true ) //cancel by buyer or bidder
        {
            cell.btnCancel.enabled = false
            cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.10)
           // cell.btnReOpen.hidden = false
        }
        else
        {
            //cell.btnReOpen.hidden = true
            cell.btnCancel.enabled = true
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1)
            //cell.btnCancel.enabled = false
        }
        if (bid.statusId == 5 ) //cancel by Spot  owner
        {
            cell.btnCancel.enabled = false
            cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.10)
           // cell.btnReOpen.hidden = true
            cell.lblAddress.text = cell.lblAddress.text! + "[Cancel By Spot owner]"
        }
       
        
        
        return cell
        
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "payment" {
            let button = sender as? UIButton
            let cell = button!.superview as! MyBidTableViewCell
            let bid = cell.bid
        }
    }
    */
}

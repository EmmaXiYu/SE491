//
//  MySpotTableViewController.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 10/27/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse
public class MySpotBiddingTableViewController: UITableViewController  {
    
    
    @IBOutlet weak var Menu: UIBarButtonItem!
     var count = 0
     var datas = [Spot] ()
     var mySpotArray:NSMutableArray = []
     override public func viewDidLoad() {
        super.viewDidLoad()
        self.readDatafromServer()
        self.title = "My Spots"
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    func readDatafromServer()
    {
        self.datas.removeAll()
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Spot")
        let currentUser = PFUser.currentUser()
        query.includeKey("owner")
        query.whereKey("owner", equalTo:currentUser!)
        query.orderByDescending("leavingTime")
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let s = Spot(object: object)
                    self.datas.append(s!)
                }
               
            }
             self.tableView.reloadData()
        }
    
    }
    //Update the View with Data from Server
    func update() {
        count++
        //update your table data here
        self.readDatafromServer()
        dispatch_async(dispatch_get_main_queue()) {
           self.tableView.reloadData()
        }
    }

    
    //This func load take PFList of Bids and convert in to a Model Bids . Currently not in use
    func GetBidEgar(bidsArray: [PFObject]?) -> [Bid] {
        var index = 0
        var bidList = [Bid]()
        for object in bidsArray! {
            
            let bi: Bid = Bid()
            let timestamp = object["Timestamp"] as! NSDate
            let value = object["Value"] as! Double
            bi.value = value
            //bi.timestamp = timestamp
            bidList.insert(bi, atIndex: index)
            index = index + 1
        }
        return bidList
    }
    
    
    ///Get in momory BID to test : currently  Not in use
    public func GetBid(i: Int) -> [Bid] {
       
        var bidList = [Bid]()
        for index in 0...i-1 {
            let bi: Bid = Bid()
            bi.value = 3 + Double(i)
            //bi.timestamp = NSDate()
            bidList.insert(bi, atIndex: index)
        }
        return bidList
    }
    
    
    //Get a bid list for spot id Not in use
    func GetBidList(spotid: String) -> [Bid] {
        var index = 0
        var bidList = [Bid]()
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        query.whereKey("SpotId", equalTo:spotid)
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    let bi: Bid = Bid()
                    let timestamp = object["Timestamp"] as! NSDate
                    let value = object["Value"] as! Double
                    bi.value = value
                    //bi.timestamp = timestamp
                    bidList.insert(bi, atIndex: index)
                    index = index + 1
                }
              
            }
        }
        return bidList
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
   
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    /**/
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MySpotLabelCell", forIndexPath: indexPath) as! SpotCellController
        let s = datas[indexPath.row]
        cell.spot = s
        cell.address.text = s.addressText
        cell.time.text = (s.timeToLeave!.description)
        if s.statusId == 4 {
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.cancelButton.enabled = false
            cell.selectionStyle = .None
            cell.userInteractionEnabled = false
        }
        return cell
        
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToMySpotBidMulti"
        {
            if let destinationVC = segue.destinationViewController as? MySpotMultiBidTableViewController{
                
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    destinationVC.spot = datas[blogIndex]
                }
                
            }
        }
        //
    }
}

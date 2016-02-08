//
//  MySpotMultiBidTableViewController.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 11/4/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse
class MySpotMultiBidTableViewController: UITableViewController {
    var bids = [Bid] ()
    var bidderRating = [Double]()
    var spot : Spot = Spot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bids"
        self.getBids()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bids.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MySpotMultiBidTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyBidLabelCell", forIndexPath: indexPath) as! MySpotMultiBidTableViewCell
        let aux = bids[indexPath.row]
        cell.bid = aux
        cell.donation.text = aux.value?.description
        cell.bidder.text = aux.bidder!.username
        cell.rating.text = aux.bidder?.getRatingAsBuyer().description
        if aux.statusId != 0 {
            cell.accept.enabled = false
            cell.reject.enabled = false
        }
        cell.table = self
        return cell
    }
    
    func getBids(){
        bids.removeAll()
        let query = PFQuery(className: "Bid")
        query.includeKey("user")
        query.includeKey("spot")
        query.whereKey("spot", equalTo: self.spot.toPFObject())
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    self.bids.removeAll()
                    for object in objects {
                        let aux = Bid(object: object)
                        self.bids.append(aux!)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
}

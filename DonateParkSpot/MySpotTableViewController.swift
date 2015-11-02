//
//  MySpotTableViewController.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 10/27/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse
class MySpotBiddingTableViewController: UITableViewController {
 var datas = [Spot] ()
    var mySpotArray:NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()

        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Spot")
        //query.whereKey("owner", equalTo: PFObject(withoutDataWithClassName:"User", objectId:CurrentUser.currentUser.username))
        //query.whereKey("owner", equalTo:"pravangsu@gmail.com")
        query.whereKey("owner", equalTo:CurrentUser.currentUser.username)
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    let s: Spot = Spot()
                    let sgp = object["SpotGeoPoint"] as! PFGeoPoint
                    let mPrice = object["minimumPrice"] as! Int
                    let Latitude: CLLocationDegrees = sgp.latitude
                    let Longtitude: CLLocationDegrees = sgp.longitude
                    let ttl = object["leavingTime"] as! String
                    let location : Location = Location()
                    location.latitude = Latitude
                    location.longitude = Longtitude
                    
                    s.legalTime = ttl
                    s.location = location
                    s.minDonation=mPrice
                    self.datas.insert(s, atIndex: 0)

                }
                self.tableView.reloadData()
            }
        }
        
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
   
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    /**/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("MyBidLabelCell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("MySpotLabelCell", forIndexPath: indexPath)
        //cell.textLabel?.text = data[indexPath.row]
        let S: Spot = datas[indexPath.row]
        //cell.textLabel?.text = S.legalTime + "  " +  String(format:"%f", S.location.altitude)
        cell.textLabel?.text = String(format:"%f", S.location.longitude) + "  " +  String(format:"%f", S.location.longitude)
        
        //var b:String = String(format:"%f", S.location.altitude)
        return cell
        
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToMySpotDetail"
        {
            if let destinationVC = segue.destinationViewController as? MySpotDetail{
                
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    destinationVC.DetailSpot = datas[blogIndex]
                }
                
            }
        }
        //
    }
}

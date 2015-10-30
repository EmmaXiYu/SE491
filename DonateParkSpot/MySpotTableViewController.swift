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
        //query.whereKey("userAccount", equalTo: PFObject(withoutDataWithClassName:"User", objectId:"SomeUserId"))
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    var s: Spot = Spot()
                    let sgp = object["SpotGeoPoint"] as! PFGeoPoint
                    let Latitude: CLLocationDegrees = sgp.latitude
                    let Longtitude: CLLocationDegrees = sgp.longitude
                    let ttl = object["leavingTime"] as! String
                    var location : Location = Location()
                    location.latitude = Latitude
                    location.longitude = Longtitude
                    
                    s.legalTime = ttl
                    s.location = location
                    self.datas.insert(s, atIndex: 0)
                    
                    // self.mySpotArray.addObject(object)
                    //let spot = object as! Spot
                  //  self.datas.insert(object, atIndex: 0)
                    // let pin = object["SpotGeoPoint"] as! PFGeoPoint
                   // let pinLatitude: CLLocationDegrees = pin.latitude
                    //let pinLongtitude: CLLocationDegrees = pin.longitude
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
        cell.textLabel?.text = S.legalTime
        return cell
        
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }
}

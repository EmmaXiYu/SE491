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
                    s.legalTime = ttl
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    var data = ["312 wabash, chicago, IL", "200 W monrow , Chicago,IL", "200 Willis tower , Chicago,IL", "324 W madison  , Chicago,IL", "Unoin Staion  , Chicago,IL"]
    
   
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }

    /**/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("MyBidLabelCell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("MySpotLabelCell", forIndexPath: indexPath)

        //cell.textLabel?.text = data[indexPath.row]
        let S: Spot = datas[indexPath.row]
        //let pin = object["SpotGeoPoint"] as! PFGeoPoint
        //let pinLatitude: CLLocationDegrees = pin.latitude
        //let pinLongtitude: CLLocationDegrees = pin.longitude
        
        
        //let s = NSString(format: "%.2f", pinLatitude)
        
        cell.textLabel?.text = S.legalTime
        //cell.usernameLabel.text = username
        
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

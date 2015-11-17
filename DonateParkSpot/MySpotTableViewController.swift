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
    
    
    @IBOutlet weak var Menu: UIBarButtonItem!
    
 var datas = [Spot] ()
    var mySpotArray:NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()

        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Spot")
         let currentUser = PFUser.currentUser()
        
        //query.whereKey("owner", equalTo: PFObject(withoutDataWithClassName:"User", objectId:CurrentUser.currentUser.username))
        
        
        //query.whereKey("owner", equalTo:"pravangsu@gmail.com")
        query.whereKey("owner", equalTo:(currentUser?.email)!)
        
        
        //query.whereKey("parent", equalTo:"pravangsu@gmail.com")

       // query.includeKey("Bid")
        
        //query.includeKey("UserID") //Use this as example to get bid
        //query.whereKey("owner", equalTo: CurrentUser.currentUser.username)
        //var test = PFUser.currentUser()!.username
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    let s: Spot = Spot()
                    let sgp = object["SpotGeoPoint"] as! PFGeoPoint
                    let mPrice = object["minimumPrice"] as! Int
                    let Latitude: CLLocationDegrees = sgp.latitude
                    let Longtitude: CLLocationDegrees = sgp.longitude
                    let ttl = object["leavingTime"] as! NSDate
                    let AddressText  = object["AddressText"] as! String
                    //let BidList  = object["Bid"] as! [PFObject]?
                    
                     //let spotId  = object.objectId
                    //let user = object["UserID"] as! PFObject
                    //let email = user["email"] as! String
                    //if(user != nil)
                    //{}
                    
                    let location : Location = Location()
                    location.latitude = Latitude
                    location.longitude = Longtitude
                    
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = NSDateFormatterStyle.LongStyle
                    formatter.timeStyle = .MediumStyle
                    
                    let dateString = formatter.stringFromDate(ttl)
                    s.legalTime = dateString
                    s.location = location
                    s.minDonation = mPrice
                    s.AddressText = AddressText
                    s.spotId = object.objectId!
                    s.StatusId = object["StatusId"] as! Int
                    //s.Bids = self.tempGetBid(2)
                    //s.Bids = self.GetBidList(spotId!)
                    //s.Bids = self.GetBidEgar(BidList!)
                    self.datas.insert(s, atIndex: 0)

                }
                
                self.tableView.reloadData()
            }
        }
        
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        

        
   
    }

    func GetBidEgar(spots: [PFObject]?) -> [Bid] {
        var index = 0
        var bidList = [Bid]()
        for object in spots! {
            
            let bi: Bid = Bid()
            let timestamp = object["Timestamp"] as! NSDate
            let value = object["Value"] as! Double
            bi.value = value
            bi.timestamp = timestamp
            bidList.insert(bi, atIndex: index)
            index = index + 1
        }
        return bidList
    }
    
    func GetBid(i: Int) -> [Bid] {
       
        var bidList = [Bid]()
        for index in 0...i-1 {
             let bi: Bid = Bid()
            bi.value = 3 + Double(i)
            bi.timestamp = NSDate()
            bidList.insert(bi, atIndex: index)
        }
        return bidList
    }
    
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
                    bi.timestamp = timestamp
                    bidList.insert(bi, atIndex: index)
                    index = index + 1
                    }
              
                }
            }
          return bidList
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
        //cell.textLabel?.text = String(format:"%f", S.location.longitude) + "  " +  String(format:"%f", S.location.longitude)
        cell.textLabel?.text = S.AddressText
        //cell.detailTextLabel!.text = S.legalTime + "        [" + String(S.Bids.count) + "]"
        cell.detailTextLabel!.text = S.legalTime + "        [..More..]"
        //var b:String = String(format:"%f", S.location.altitude)
        return cell
        
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToMySpotBidMulti"
        {
            if let destinationVC = segue.destinationViewController as? MySpotMultiBidTableViewController{
                
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    destinationVC.DetailSpot = datas[blogIndex]
                }
                
            }
        }
        //
    }
}

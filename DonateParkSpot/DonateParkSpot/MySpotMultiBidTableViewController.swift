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
 var datas = [Bid] ()
 var DetailSpot : Spot = Spot()
 //var currentIndex : Int =  -1
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        GetBidList(DetailSpot.spotId)
        // self.tableView.userInteractionEnabled = false
        
    }

    func GetBidList(spotid: String)  {
        var index = 0
        //var bidList = [Bid]()
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
                    let userId = object["UserId"] as! String
                    bi.value = value
                    bi.timestamp = timestamp
                    bi.UserId = userId
                    bi.bidId = object.objectId!
                    self.datas.insert(bi, atIndex: index)
                    index = index + 1
                }
                if(self.datas.count == 0)
                {
                    self.datas.insert(self.GetEmptyBid(), atIndex: 0)
                }
                self.tableView.reloadData()
            }
        }
        
    }
    func GetEmptyBid() -> Bid {
        
        let bid = Bid()
       bid.value = Double(0)
       bid.timestamp = NSDate()
       return bid
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return DetailSpot.Bids.count
        return datas.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MySpotMultiBidTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyBidLabelCell", forIndexPath: indexPath) as!
MySpotMultiBidTableViewCell
        
        cell.bid =  datas[indexPath.row]
        //let bid: Bid = DetailSpot.Bids[indexPath.row]
         let bid: Bid = datas[indexPath.row]
        //currentIndex = indexPath.row
        cell.lblDonetion.text = String(bid.value!)
        cell.lblBidder.text = bid.UserId
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        let dateString = formatter.stringFromDate(bid.timestamp!)
        cell.lblTimr.text = dateString  //String(bid.timestamp!)
         
       // (cell.contentView.viewWithTag(11) as! UILabel).text = String(bid.value!)
        //(cell.contentView.viewWithTag(12) as! UILabel).text = String(bid.timestamp!)
        if(bid.value < 0.01)
        {
            //let lbl : UILabel = (cell.contentView.viewWithTag(12) as! UILabel)
            cell.lblTimr.text = "No Bid yet"
            cell.lblTimr.textColor = UIColor.redColor()
        }
        
        
        //cell.textLabel?.text = S.legalTime + "  " +  String(format:"%f", S.location.altitude)
        //cell.textLabel?.text = String(format:"%f", S.location.longitude) + "  " +  String(format:"%f", S.location.longitude)
        //cell.textLabel?.text = S.AddressText
        //cell.detailTextLabel!.text = S.legalTime + "        [" + String(S.Bids.count) + "]"
        //var b:String = String(format:"%f", S.location.altitude)
        //cell.contentView.userInteractionEnabled = false
        cell.btnAccept.addTarget(self, action: "btnAccept_click:", forControlEvents: .TouchUpInside)
        cell.btnReject.addTarget(self, action: "btnReject_click:", forControlEvents: .TouchUpInside)
        cell.btnAccept.tag = indexPath.row
         cell.btnReject.tag = indexPath.row
        return cell
        
    }
    
    func btnAccept_click(sender: UIButton!) {
       
        let currentbid : Bid = datas[sender.tag]
        print("btnAccept_click from main  at " + String(sender.tag) + "  value: " + String(currentbid.value))
        var prefQuery = PFQuery(className: "Spot")
        prefQuery.getObjectInBackgroundWithId(DetailSpot.spotId){
            (prefObj: PFObject?, error: NSError?) -> Void in
            if error != nil {
                self.showmessage("Error on Acceped")
                print(error)
                
            } else if let prefObj = prefObj {
                prefObj["StatusId"] = 2
                prefObj["AcctepedBidId"] = currentbid.bidId
                prefObj.saveInBackgroundWithTarget(sender, selector: nil)
                self.showmessage("Successfully Acceped")
                
            }
        }

    }
    func btnReject_click(sender: UIButton!) {
        let currentbid : Bid = datas[sender.tag]
        print("btnReject_click  from main at  " + String(sender.tag) + "  value: " + String(currentbid.value))
        var prefQuery = PFQuery(className: "Spot")
        prefQuery.getObjectInBackgroundWithId(DetailSpot.spotId){
            (prefObj: PFObject?, error: NSError?) -> Void in
            if error != nil {
               self.showmessage("Error on Reject")
                print(error)
              
            } else if let prefObj = prefObj {
                prefObj["StatusId"] = 4
                prefObj["AcctepedBidId"] = currentbid.bidId
                prefObj.saveInBackgroundWithTarget(sender, selector: nil)
                self.showmessage("Successfully Rejected")
               
           }
        }
    }
    
        func showmessage ( msg : String) -> Void
        {
        
            let refreshAlert = UIAlertView()
            refreshAlert.title = "Donate parkspot"
            refreshAlert.message = msg
            //refreshAlert.addButtonWithTitle("Cancel")
            refreshAlert.addButtonWithTitle("OK")
            refreshAlert.show()
        }
    
    /*
    @IBAction func AcceptButton_Clicked(sender: UIButton) {
    
    let bid: Bid = datas[self.currentIndex]
    var currentIndex : Double =  bid.value!
        print("tapped button xxxx")
    }
    
    func btnAccept_click(sender: UIButton!) {
        
       var d = 99
        
    }
   */

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

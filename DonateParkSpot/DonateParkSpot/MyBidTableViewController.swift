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
    
   
    @IBOutlet weak var Menu: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetBidList()
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        


    }
    
    
    func GetBidList()  {
        var index = 0
        //var bidList = [Bid]()
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        
        query.whereKey("UserId", equalTo:"pravangsu@gmail.com")
        
       /*
        TODO: do in Next Release , Winter Quater
        let currentUser = PFUser.currentUser()
        query.whereKey("owner", equalTo: PFObject(withoutDataWithClassName:"User", objectId:currentUser))
        */
        
        
        query.includeKey("Spot")
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                     let bi: Bid = Bid()
                    
                    if let pointer = object["Spot"] as? PFObject {
                        bi.Address = pointer["AddressText"] as! String!
                    }
                    bi.value =  object["Value"] as? Double
                    bi.timestamp = object["Timestamp"] as? NSDate
                    bi.UserId = object["UserId"] as! String
                    if(object["CancelByBidder"] != nil)
                    {
                        bi.CancelByBidder = object["CancelByBidder"] as! Bool
                    }
                    bi.bidId = object.objectId!
                    bi.StatusId = object["StatusId"] as! Int
                    self.datas.insert(bi, atIndex: index)
                    index = index + 1 
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
          return datas.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyBidCell", forIndexPath: indexPath) as!
        MyBidTableViewCell
        
        return updateCell(cell , currentIndex : indexPath.row)

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    func updateCell(objCell : MyBidTableViewCell , currentIndex : Int) -> MyBidTableViewCell
    {
        
        objCell.bid =  datas[currentIndex]
        let bid: Bid = datas[currentIndex]
        
        objCell.lblDonetion.text = String(bid.value!)
        objCell.lblBidder.text = bid.UserId
        objCell.lblAddress.text = bid.Address
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
       // let dateString = formatter.stringFromDate(bid.timestamp!)

        
        self.updateCellColor(objCell , CancelByBidder :  bid.CancelByBidder)
        
    
       objCell.btnCancel.addTarget(self, action: "btnCancel_click:", forControlEvents: .TouchUpInside)
       objCell.btnCancel.tag = currentIndex
        
        return objCell
    }
    
    func updateCellColor(objCell : MyBidTableViewCell , CancelByBidder : Bool)-> Void
    {
        if (CancelByBidder == true ) //cancel by buyer or bidder
        {
            objCell.btnCancel.enabled = false
            objCell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.10)
        }
     
    }
    func btnCancel_click(sender: UIButton!) {
        
        let currentbid : Bid = datas[sender.tag]
        print("btnCancel_click from main  at " + String(sender.tag) + "  value: " + String(currentbid.value))
        if( currentbid.CancelByBidder  == false)
        {
            self.updateBid(currentbid, status :2,  sender: sender!)
            currentbid.CancelByBidder = true
            let cell = getCellForButton(sender)
            self.updateCellColor(cell , CancelByBidder :  currentbid.CancelByBidder)
        }
        else
        {
            self.showmessage("Sorry!  You already canceled this bid")
        }
    }
    
    func updateBid(currentbid : Bid, status :Int,  sender: UIButton!)-> Void
    {
        let prefQuery = PFQuery(className: "Bid")
        prefQuery.getObjectInBackgroundWithId(currentbid.bidId){
            (prefObj: PFObject?, error: NSError?) -> Void in
            if error != nil {
                self.showmessage("Error on Cancel bid")
                print(error)
            } else if let prefObj = prefObj {
                prefObj["CancelByBidder"] = true
                prefObj.saveInBackgroundWithTarget(sender, selector: nil)
                self.showmessage(" Bid canceled Successfully" )
                
            }
        }
    }

    
    func getCellForButton(sender: UIButton!)-> MyBidTableViewCell
    {
        let button = sender as UIButton
        let view = button.superview!
        let cell = view.superview as! MyBidTableViewCell
        //let indexPath = tableView.indexPathForCell(cell)
        return cell
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

}

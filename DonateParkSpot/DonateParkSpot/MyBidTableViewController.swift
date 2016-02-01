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
        self.getRating()
        self.GetBidList()
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        


    }
    
    func getRating(){
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Rating")
        query.findObjectsInBackgroundWithBlock{(objects:[PFObject]?,error:NSError?) -> Void in
            if error == nil{
                for object in objects!{
                    let name = object["userName"] as! String
                    let score = object["score"] as! Int
                    if(self.ratingScore[name] != nil){
                        self.ratingScore[name] = self.ratingScore[name]!+Double(score)
                        self.ratingCount[name] = self.ratingCount[name]!+1
                    }
                    else{
                        self.ratingScore[name] = Double(score)
                        self.ratingCount[name] = 0
                    }
                }
                for name in self.ratingScore.keys{
                    self.ratingScore[name] = self.formulateScore(self.ratingScore[name]!,count: self.ratingCount[name]!)
                }
                
            }
        }
    }
    
    func GetBidList()  {
        var index = 0
        //var bidList = [Bid]()
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        
        //query.whereKey("UserId", equalTo:"pravangsu@gmail.com")
        //get the user id of the current user
       query.whereKey("UserId", equalTo:(PFUser.currentUser()?.username)!)
        
       /*
        TODO: do in Next Release , Winter Quater
        let currentUser = PFUser.currentUser()
        query.whereKey("owner", equalTo: PFObject(withoutDataWithClassName:"User", objectId:currentUser))
        */
        
        
        query.includeKey("spot")
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                     let bi: Bid = Bid()
                    
                    if let pointer = object["spot"] as? PFObject {
                        bi.Address = pointer["addressText"] as! String!
                    }
                    if(object["value"] != nil)
                    {bi.value =  object["value"] as? Double}
                    else
                    {bi.value = 0}
                    
                    bi.timestamp = object["Timestamp"] as? NSDate
                    bi.UserId = object["UserId"] as! String
                    if(object["CancelByBidder"] != nil)
                    {
                        bi.CancelByBidder = object["CancelByBidder"] as! Bool
                    }
                    bi.bidId = object.objectId!
                    if(object["StatusId"] != nil)
                    {
                    bi.StatusId = object["StatusId"] as! Int
                    }
                    else
                        if(object["StatusId"] != nil)
                        {
                            bi.StatusId = 0
                    }
                    
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
    
    func updateRating(username:String, score: Int,statusId:Int)->Void{
        let update = PFObject(className: "Rating")
        update["name"] = username
        update["socre"] = score
        update["statusId"] = statusId
        update.saveInBackgroundWithBlock{
            (success:Bool,error:NSError?) -> Void in
            if(success){
                }
            }
    }
    
    func formulateScore(rating:Double,count:Int) ->Double{
        return (rating/Double(count)+1.0)*2.5;
    }
    
    func increaseRating ( rating: Double, count: Int ) -> Double{
        var score: Double = (0.4*rating-1)*Double(count);
        score = score+1;
        return (score/Double(count)+1.0)*2.5;
    }
    
    func decreaseRating ( rating: Double, count: Int ) -> Double{
        var score: Double = (0.4*rating-1)*Double(count);
        score = score-1;
        return (score/Double(count)+1.0)*2.5;
    }


}

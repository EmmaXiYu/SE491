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
    var rating: Double = 0;
    var count: Int = 0;
    var ratingScore = [String:Double]()
    var ratingCount = [String:Int]()
    
var bidNoPayAutoCancelTime : Int = 4  // Set a intitial value,
 //var currentIndex : Int =  -1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRating()
        self.title = "Bids"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        GetBidList(DetailSpot.spotId)
        var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "update", userInfo: nil, repeats: true)

        // self.tableView.userInteractionEnabled = false
        
    }
    func update() {
        //update your table data here
        self.GetBidList(DetailSpot.spotId)
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    
//    func getRating(){
//        var query: PFQuery = PFQuery()
//        query = PFQuery(className: "Rating")
//        query.findObjectsInBackgroundWithBlock{(objects:[PFObject]?,error:NSError?) -> Void in
//            if error == nil{
//                for object in objects!{
//                    let name = object["userName"] as! String
//                    let score = object["score"] as! Int
//                    if(self.ratingScore[name] != nil){
//                        self.ratingScore[name] = self.ratingScore[name]!+Double(score)
//                        self.ratingCount[name] = self.ratingCount[name]!+1
//                    }
//                    else{
//                        self.ratingScore[name] = Double(score)
//                        self.ratingCount[name] = 0
//                    }
//                }
//                for name in self.ratingScore.keys{
//                    self.ratingScore[name] = self.formulateScore(self.ratingScore[name]!,count: self.ratingCount[name]!)
//                }
//                
//            }
//        }
//    }
    

    func getRating(){
        var users = [String]()
        var query:PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        query.whereKey("UserId", equalTo:(PFUser.currentUser()?.username)!)
        query.selectKeys(["UserId"])
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects!{
                    let name = object["userName"] as! String
                    users.append(name)
                    if(self.ratingScore[name] == nil){
                        self.ratingScore[name] = 0
                        self.ratingCount[name] = 0
                    }
                }
            }
        }
        getBuyerRating(users)
        getSellerRating(users)
        for name in self.ratingScore.keys{
            self.ratingScore[name] = self.formulateScore(self.ratingScore[name]!,count: self.ratingCount[name]!)
        }
    }
    
    func getBuyerRating(buyers:[String])-> Void{
        var query:PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        query.whereKey("UserId", containedIn:buyers)
        query.selectKeys(["StatusId","UserId"])
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects!{
                    let buyerName = object["UserId"] as! String
                    let statusId = object["StatusId"] as! Int
                    if(statusId == 3){
                        self.ratingScore[buyerName] = self.ratingScore[buyerName]!+1.0
                        self.ratingCount[buyerName] = self.ratingCount[buyerName]!+1
                    }
                    else if(statusId == 6){
                        self.ratingScore[buyerName] = self.ratingScore[buyerName]!-1.0
                        self.ratingCount[buyerName] = self.ratingCount[buyerName]!+1
                    }
                }
            }
        }
    }
    
    func getSellerRating(sellers:[String]) -> Void{
        var query:PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        let innerQuery = PFQuery(className: "User")
        innerQuery.whereKey("username", containedIn:sellers)
        query.whereKey("user", matchesQuery:innerQuery)
        query.selectKeys(["StatusId","user"])
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects!{
                    var sellerName:String = ""
                    if let pointer = object["user"] as? PFObject{
                        sellerName = pointer["username"] as! String!
                    }
                    let statusId = object["StatusId"] as! Int
                    if(statusId == 3){
                        self.ratingScore[sellerName] = self.ratingScore[sellerName]!+1.0
                        self.ratingCount[sellerName] = self.ratingCount[sellerName]!+1
                    }
                    else if(statusId == 7){
                        self.ratingScore[sellerName] = self.ratingScore[sellerName]!-1.0
                        self.ratingCount[sellerName] = self.ratingCount[sellerName]!+1
                    }
                }
            }
        }
        
        
    }
    

    

    
    public func GetBidList(spotid: String)  {
        self.getBidNoPayAutoCancelTime()
        
        self.datas.removeAll()
        var index = 0
        //var bidList = [Bid]()
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        var queryUser :PFQuery = PFQuery()
        queryUser = PFQuery(className: "User")
      //  query.whereKey("Spot", equalTo:spotid)
        //query.whereKey("spot", equalTo: PFObject(withoutDataWithClassName:"spot", objectId:spotid))
        query.includeKey("user")
        // Add a where condition , to get the spot for the login user
        query.whereKey("spot", equalTo: PFObject(withoutDataWithClassName:"Spot", objectId:spotid))
        
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    let bi: Bid = Bid()
                    if(object["Timestamp"] != nil){
                        bi.timestamp =  object["Timestamp"] as! NSDate
                    } else {
                        bi.timestamp =   NSDate()
                    }
                    let value = object["value"] as! Double
                    let userId = object["user"] as! PFUser
                    bi.value = value
                    
                    bi.UserId = userId.username!
                    bi.bidId = object.objectId!
                    //bi.rating = self.ratingScore[bi.UserId]!   //PB02062016
                    if(object["StatusId"] != nil){
                        bi.StatusId = object["StatusId"] as! Int
                    } else {
                        bi.StatusId = 0
                       // no status found , put a default status. o Means bid is just created
                    }
                    
                    if(object["BidAcceptTime"] != nil)
                    {
                        bi.BidAcceptTime = object["BidAcceptTime"] as! NSDate
                    }
                    
                    self.autoCancelNoPayBid(bi,noPayAutoCancelTime : self.bidNoPayAutoCancelTime) //cancel the bid if payment not recieved on time
                    
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
    func autoCancelNoPayBid(bid : Bid, noPayAutoCancelTime :Int)-> Void
    {
        if(bid.BidAcceptTime != nil)
        {
            if((self.MinuteElaps(bid.BidAcceptTime!) > self.bidNoPayAutoCancelTime ) && bid.StatusId == 2)
            {
                // status 2 : Accepted
                //staus 3: payment recieved
                //status 6 : Auto Reject due to non payment in time frame
                print("time exceed and cancel the bid")
                self.updateBid(bid, status :6,  sender: nil) //rejected
            }
            
        }
    }
    
    
    // this function return number of minutes from current time
    func MinuteElaps(bidAcceptDate : NSDate) -> Int
    {
        
            let currentDate = NSDate()
            let distanceBetweenDates = currentDate.timeIntervalSinceDate(bidAcceptDate)
            let secondsInAnMinute = 60.0;
            let minutesElapsed = distanceBetweenDates / secondsInAnMinute;
            print(minutesElapsed)
           // println(distanceBetweenDates)
            return Int(minutesElapsed)
        
    }
    
    // Read from configation setting database (Parse) table , the time in minutes to cancel the Bid for no payment after accepted by the Seller
    func getBidNoPayAutoCancelTime() -> Void
    {
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "APP_SETING")  // read from database
        query.whereKey("SETING_NAME", equalTo:"BID_NO_PAY_AUTO_CANCEL_TIME")
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    if(object["SETTING_VALUE"] != nil)
                    {
                        self.bidNoPayAutoCancelTime =  Int(object["SETTING_VALUE"] as! String)!
                    }
                    print("bidNoPayAutoCancelTime-->" + String(self.bidNoPayAutoCancelTime) )
                }
            }
        }
    }
   
    // Retun a empty Bid. This use to show a readonly message if no bid is present for the spot. This hepl to show somthing in the screen. User can not do anything on this bid. This bid not saved in data base. Just a display only place holder for show a message
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MyBidLabelCell", forIndexPath: indexPath) as! MySpotMultiBidTableViewCell
       
        /*
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
        
        
        if(DetailSpot.StatusId == 2)
        {
            //If any bid Accepted than Spot staus also , than disable all Accept button in table
            cell.btnAccept.enabled = false
            //cell.btnReject.enabled = false
        }
        //if (bid.StatusId == 4 ||  bid.StatusId == 2)
        //{
        
        
            if (bid.StatusId == 2 ) //Accepted
            {
                cell.btnAccept.enabled = false
                cell.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.10)
            }
            
            if ( bid.StatusId == 4)  //Rejected
            {
                cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.10)
                cell.btnReject.enabled = false
            }
        //}
        cell.btnAccept.addTarget(self, action: "btnAccept_click:", forControlEvents: .TouchUpInside)
        cell.btnReject.addTarget(self, action: "btnReject_click:", forControlEvents: .TouchUpInside)
        cell.btnAccept.tag = indexPath.row
        cell.btnReject.tag = indexPath.row
        return cell
*/
        return updateCell(cell , currentIndex : indexPath.row)
        
    }
    func updateCell(objCell : MySpotMultiBidTableViewCell , currentIndex : Int) -> MySpotMultiBidTableViewCell
    {
    
        objCell.bid =  datas[currentIndex]
        let bid: Bid = datas[currentIndex]

        objCell.lblDonetion.text = String(bid.value!)
        objCell.lblBidder.text = bid.UserId
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.NoStyle
        formatter.timeStyle = .ShortStyle
        let dateString = formatter.stringFromDate(bid.timestamp!)
        objCell.lblTimr.text = dateString  //String(bid.timestamp!) 
        
     
        if(bid.value < 0.01)
        {
            // This is the Bid created by GetEmptyBid func. User can do nothing on this . All button are disable
            objCell.lblTimr.text = "No Bid yet"
            objCell.lblTimr.textColor = UIColor.redColor()
            objCell.btnAccept.enabled = false
            objCell.btnReject.enabled = false
        }
        
        if(DetailSpot.StatusId == 2)
        {
            //If any bid Accepted than Spot staus also , than disable all Accept button in table
            objCell.btnAccept.enabled = false
        }
        self.updateCellColor(objCell , StatusId :  bid.StatusId)

        // Add a event hander to bid button
        objCell.btnAccept.addTarget(self, action: "btnAccept_click:", forControlEvents: .TouchUpInside)
        objCell.btnReject.addTarget(self, action: "btnReject_click:", forControlEvents: .TouchUpInside)
        objCell.btnAccept.tag = currentIndex
        objCell.btnReject.tag = currentIndex
    
    return objCell
    }
    
    func updateCellColor(objCell : MySpotMultiBidTableViewCell , StatusId : Int)-> Void
    {
        if (StatusId == 2 ) //Accepted
        {
            objCell.btnAccept.enabled = false
            objCell.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.10)
        }
        
        if ( StatusId == 4)  //Rejected
        {
            objCell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.10)
            objCell.btnReject.enabled = false
        }
    }
    func btnAccept_click(sender: UIButton!) {
       
         let currentbid : Bid = datas[sender.tag]
         print("btnAccept_click from main  at " + String(sender.tag) + "  value: " + String(currentbid.value))
        if( DetailSpot.StatusId != 2)
        {
            // Update the bid and spot with status 2. Status 2 means accepted
         self.updateBid(currentbid, status :2,  sender: sender!)
         self.updateSpot(currentbid, status :2,  sender: sender!)
         DetailSpot.StatusId = 2
        currentbid.StatusId = 2
        let cell = getCellForButton(sender)
        self.updateCellColor(cell , StatusId :  currentbid.StatusId)
        }
        else
        {
            // Only one bid ca be accepted per sopt
          self.showmessage("Sorry!  You already acceped another bid")
        }
         //self.tableView.reloadData()
       /*
        let prefQuery = PFQuery(className: "Spot")
        prefQuery.getObjectInBackgroundWithId(DetailSpot.spotId){
            (prefObj: PFObject?, error: NSError?) -> Void in
            if error != nil {
                self.showmessage("Error on Acceped bid")
                print(error)
                
            } else if let prefObj = prefObj {
                prefObj["StatusId"] = 2
                prefObj["AcctepedBidId"] = currentbid.bidId
                prefObj.saveInBackgroundWithTarget(sender, selector: nil)
                self.showmessage("Successfully Acceped bid")
                
            }
        }
*/

    }
 // Fires when reject button click on the bid
    func btnReject_click(sender: UIButton!) {
        let currentbid : Bid = datas[sender.tag]
        print("btnReject_click  from main at  " + String(sender.tag) + "  value: " + String(currentbid.value))
        self.updateBid(currentbid, status :4,  sender: sender!) // Status 4 means rejected
        currentbid.StatusId = 4
        // get the associetd cell for the button clicked
        let cell = getCellForButton(sender)
        self.updateCellColor(cell , StatusId :  currentbid.StatusId)

         //self.tableView.reloadData()
       /*
        let prefQuery = PFQuery(className: "Spot")
        prefQuery.getObjectInBackgroundWithId(DetailSpot.spotId){
            (prefObj: PFObject?, error: NSError?) -> Void in
            if error != nil {
               self.showmessage("Error on Reject bid")
                print(error)
              
            } else if let prefObj = prefObj {
                prefObj["StatusId"] = 4
                prefObj["AcctepedBidId"] = currentbid.bidId
                prefObj.saveInBackgroundWithTarget(sender, selector: nil)
                self.showmessage("Successfully Rejected bid")
               
           }
        }
        */
    }
    // Takes a button in a cell as parameter and return the instance of the cell, who hold this button. Retuen container cell of the button
    func getCellForButton(sender: UIButton!)-> MySpotMultiBidTableViewCell
    {
        let button = sender as UIButton
        let view = button.superview!
        let cell = view.superview as! MySpotMultiBidTableViewCell
        //let indexPath = tableView.indexPathForCell(cell)
        return cell
    }
    
    
    // Update the spot in Database (Parse)
    func updateSpot(currentbid : Bid, status :Int,  sender: UIButton!)-> Void
    {
        let prefQuery = PFQuery(className: "Spot")
        prefQuery.getObjectInBackgroundWithId(DetailSpot.spotId){
            (prefObj: PFObject?, error: NSError?) -> Void in
            if error != nil {
                self.showmessage("Error on Acceped bid")
                print(error)
                
            } else if let prefObj = prefObj {
                prefObj["StatusId"] = status
                if(status == 2) //Accepted
                {
                    // If any bid have been accpepted. Associated the Bid with the spot
                    prefObj["AcctepedBidId"] = currentbid.bidId
                }
                prefObj.saveInBackgroundWithTarget(sender, selector: nil)
                self.showmessage("Successfully Acceped bid")
                
            }
        }
    }
    
     // Update the Bid in Database (Parse)
    func updateBid(currentbid : Bid, status :Int,  sender: UIButton!)-> Void
    {
        let prefQuery = PFQuery(className: "Bid")
        prefQuery.getObjectInBackgroundWithId(currentbid.bidId){
            (prefObj: PFObject?, error: NSError?) -> Void in
            if error != nil {
                //self.showmessage("Error on Acceped bid")
                print(error)
            } else if let prefObj = prefObj {
                prefObj["StatusId"] = status
                if(status == 2)//Accepted
                {
                    prefObj["BidAcceptTime"] = NSDate()
                }
                if(status == 6)//cancel for No payment
                {
                    // Store the No Payment Cancel Time for loging purpose
                    prefObj["NoPaymentCancelTime"] = NSDate()
                }
                
                
                prefObj.saveInBackgroundWithTarget(sender, selector: nil)
                //self.showmessage("Successfully Acceped bid")
                
            }
        }
    }
    
    
    // Shows a popup alert in the screen
        func showmessage ( msg : String) -> Void
        {
        
            let refreshAlert = UIAlertView()
            refreshAlert.title = "Donate parkspot"
            refreshAlert.message = msg
            //refreshAlert.addButtonWithTitle("Cancel")
            refreshAlert.addButtonWithTitle("OK")
            refreshAlert.show()
        }
    
    
    func formulateScore(rating:Double,count:Int) ->Double{
        if count == 0{
            return 0;
        }
        else{
            return (rating/Double(count)+1.0)*2.5;
        }
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

//
//  BackTableVC.swift
//  DonateParkSpot
//
//  Created by Apple on 10/31/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation
import Parse

class BackTableVC: UITableViewController

{
    var TableArray = [String]()
    override func viewDidLoad() {
        TableArray = ["Map", "Account", "My Spots", "My Bids", "Settings", "Logout"]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cell=tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath)
        as UITableViewCell
        
        
        cell.textLabel?.text = TableArray[indexPath.row]
        
        
        
        
        return cell
    }
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
          if segue.identifier == "Logout" {
               PFUser.logOut()
               NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
          }
     }
   

}

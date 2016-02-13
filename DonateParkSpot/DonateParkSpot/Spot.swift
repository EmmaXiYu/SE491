//
//  spot.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 10/14/15.
//  Copyright © 2015 SE491. All rights reserved.
//

import Foundation
import Parse

class Spot {
    
    var location : Location = Location()
    var type : Int = 0
    var rate : Double = 0.0
    var timeLeft : Int = 0
    var minDonation : Int = 0
    var legalTime : String = ""
    var timeToLeave : NSDate?
    var owner : PFUser?
    var addressText: String = ""
    var statusId : Int = -1 // 1: Active and open for bid; 2 : bid Accepted; 3: Donetion Recieved and closed 4: Rejected
    
    
   // var Bids : [Bid] = [Bid]()//Emma think spots should not have bids, each bid should has a spot. Each bid
    //in database should have a pointer, points to a perticular spot. What do u guys think?
    //Pravangsu : Emma is correct on var Bids : [Bid] = [Bid]()
    var spotId : String = "" //need to get bid from server
    
    func toPFObject() -> PFObject {
        let result = PFObject(className: "Spot")
        result["SpotGeoPoint"] = PFGeoPoint(latitude: location.latitude!, longitude: location.longitude!)
        result["type"] = type
        result["rate"] = rate
        result["timeLeft"] = timeLeft
        result["minimumPrice"] = minDonation
        result["leavingTime"] = timeToLeave == nil ? NSNull() : timeToLeave
        result["owner"] = owner == nil ? NSNull() : owner
        result["StatusId"] = statusId
        result["addressText"] = addressText
        result["legalTime"] = legalTime
        result.objectId = spotId
        return result
    }
    
    init?(object: PFObject?){
        if object == nil {
            return nil
        }
        location = Location(object: object?["SpotGeoPoint"] as? PFGeoPoint)
        type = object?["type"] as! Int
        rate = object?["rate"] as! Double
        timeLeft = object?["timeLeft"] as! Int
        minDonation = object?["minimumPrice"] as! Int
        timeToLeave = object?["leavingTime"] as? NSDate
        owner = object?["owner"] as? PFUser
        if(object?["StatusId"] != nil)
        {
            statusId = object?["StatusId"] as! Int
        }
        else
        {
            statusId = 1
        }
        addressText = object?["addressText"] == nil ? "" : object?["addressText"] as! String
        legalTime = object?["legalTime"] as! String
        spotId = (object?.objectId)!
    }
    
    init(){
        
    }
}
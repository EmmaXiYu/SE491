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
    var type : String = ""
    var rate : Double = 0.0
    var timeLeft : Int = 0
    var minDonation : Int = 0
    var legalTime = ""
    var timeToLeave : NSDate?
    var owner : PFUser = PFUser()
    var AddressText: String = ""
    var StatusId : Int = -1 // 1: Active and open for bid; 2 : bid Accepted; 3: Donetion Recieved and closed 4: Rejected
    var AcctepedBidId : String = ""
    
   // var Bids : [Bid] = [Bid]()//Emma think spots should not have bids, each bid should has a spot. Each bid
    //in database should have a pointer, points to a perticular spot. What do u guys think?
    //Pravangsu : Emma is correct on var Bids : [Bid] = [Bid]()
    var spotId : String = "" //need to get bid from server
    
    func toPFObject() -> PFObject {
        let result = PFObject(className: "Spot")
        result["Location"] = PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
        result["Type"] = type
        result["Rate"] = rate
        result["TimeLeft"] = timeLeft
        result["MinDonation"] = minDonation
        result["LegalTime"] = legalTime
        result["TimeToLeave"] = timeToLeave
        result["Owner"] = owner
        
        
        return result
    }
}
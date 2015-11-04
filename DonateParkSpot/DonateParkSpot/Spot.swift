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
    var minDonation = 0
    var legalTime = ""
    var timeToLeave : NSDate?
    var owner : PFUser = PFUser()
    
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
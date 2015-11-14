//
//  Bid.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 10/27/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation

class Bid {
    
    var spot : Spot?
    var timestamp : NSDate?
    var value : Double?
    var UserId : String = ""
    var bidId  :String = "" //Will use for updating (Accept/  reject bid)
    var StatusId : Int = 1   //  Status by Seller
    var CancelByBidder : Bool = false // Indicate if cancel by Buyer  
    
}
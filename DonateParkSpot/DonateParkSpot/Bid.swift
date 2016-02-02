//
//  Bid.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 10/27/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation

public class Bid {
    
    var spot : Spot?
    var timestamp : NSDate? //Time of bidding
    var value : Double?
    var UserId : String = ""
    var bidId  :String = "" //Will use for updating (Accept/  reject bid)
    var StatusId : Int = 1   //  Status by Seller
    var CancelByBidder : Bool = false // Indicate if cancel by Buyer  
    var Address :String = ""  // only Client. This will not save in databse. Will be use to Display in my bid page
    var  BidAcceptTime: NSDate? // Time of Accept bid by seller.  This will use be count to time if buyer make a payment with in specified time or not
    var rating:Double = 0
    
}
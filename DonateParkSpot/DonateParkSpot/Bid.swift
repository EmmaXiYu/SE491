//
//  Bid.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 10/27/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation
import Parse 

public class Bid {
    private var oldStatus: Int? = 0
    var spot : Spot?
    var value : Double?
    var bidder : PFUser?
    var bidId  :String?
    private var status : Int = 0
    var statusId : Int? {
        get {
            return status
        }
        set(newStatus){
            self.oldStatus = self.status
            self.status = newStatus!
        }
    }
    var cancelByBidder : Bool? = false // Indicate if cancel by Buyer
    var address :String = ""  // only Client. This will not save in databse. Will be use to Display in my bid page
    var bidAcceptTime: NSDate? // Time of Accept bid by seller.  This will use be count to time if buyer make a payment with in specified time or not
    var timeFrame:String?
    var noPaymentCancelTime: NSDate?
    var paymentMakeTime: NSDate?
    var createAt: NSDate?
    
    init?(object: PFObject?){
        if object == nil {
            return nil
        }
        bidAcceptTime = object?["BidAcceptTime"] as? NSDate
        cancelByBidder = object?["CancelByBidder"] as? Bool
        noPaymentCancelTime = object?["NoPaymentCancelTime"] as? NSDate
        paymentMakeTime = object?["PaymentMakeTime"] as? NSDate
        statusId = object?["StatusId"]  as? Int
        spot = Spot(object: object?["spot"] as? PFObject)
        bidder = object?["user"] as? PFUser
        value = object?["value"] as? Double
        oldStatus = object?["oldStatus"] as? Int
        bidId = object?.objectId
        createAt = object?.createdAt
        
    }
    
    init(){
        
    }
    
    func toPFObjet() -> PFObject{
        let aux = PFObject(className: "Bid")
        if bidId != nil {
            aux.objectId = bidId
        }
        aux["BidAcceptTime"] = bidAcceptTime == nil ? NSNull() : bidAcceptTime
        aux["CancelByBidder"] = cancelByBidder == nil ? NSNull() : cancelByBidder
        aux["NoPaymentCancelTime"] = noPaymentCancelTime  == nil ? NSNull() : noPaymentCancelTime
        aux["PaymentMakeTime"] = paymentMakeTime  == nil ? NSNull() : paymentMakeTime
        aux["StatusId"] = statusId
        aux["spot"] = spot == nil ? NSNull() : spot?.toPFObject()
        aux["user"] = bidder
        aux["value"] = value
        aux["oldStatus"] = oldStatus
        return aux
    }
    
    
}
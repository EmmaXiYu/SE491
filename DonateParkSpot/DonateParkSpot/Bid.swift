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
    
    var spot : Spot?
    var value : Double?
    var bidder : PFUser?
    var bidId  :String? = "" //Will use for updating (Accept/  reject bid)
    var statusId : Int? = 1   //  Status by Seller
    var cancelByBidder : Bool? = false // Indicate if cancel by Buyer
    var address :String = ""  // only Client. This will not save in databse. Will be use to Display in my bid page
    var bidAcceptTime: NSDate? // Time of Accept bid by seller.  This will use be count to time if buyer make a payment with in specified time or not
    var noPaymentCancelTime: NSDate?
    var paymentMakeTime: NSDate?
    
    init(object: PFObject?){
        if object == nil {
            return
        }
        bidAcceptTime = object?["BidAcceptTime"] as? NSDate
        cancelByBidder = object?["CancelByBidder"] as? Bool
        noPaymentCancelTime = object?["NoPaymentCancelTime"] as? NSDate
        paymentMakeTime = object?["PaymentMakeTime"] as? NSDate
        statusId = object?["StatusId"]  as? Int
        spot = Spot(object: object?["spot"] as? PFObject)
        bidder = object?["user"] as? PFUser
        value = object?["value"] as? Double
        bidId = object?.objectId
    }
    
    init(){
        
    }
    
    func toPFObjet() -> PFObject{
        let aux = PFObject(className: "Bid")
        aux.objectId = bidId
        aux["BidAcceptTime"] = bidAcceptTime
        aux["CancelByBidder"] = cancelByBidder
        aux["NoPaymentCancelTime"] = noPaymentCancelTime
        aux["PaymentMakeTime"] = paymentMakeTime
        aux["StatusId"] = statusId
        aux["spot"] = spot?.toPFObject()
        aux["user"] = bidder
        aux["value"] = value
        return aux
    }
    
    
}
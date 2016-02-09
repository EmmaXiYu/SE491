//
//  User.swift
//  DonateParkSpot
//
//  Created by Apple on 10/24/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse
extension PFUser {
    func getRatingAsBuyer() -> Double{
        let query = PFQuery(className: "Bid")
        query.whereKey("user", equalTo: self)
        var results = [PFObject]()
        do{
            try results = query.findObjects()
        }catch{
            return 0.0
        }
        if results.count == 0 {
            return 0.0
        }
        var sum3 = 0.0, sum6 = 0.0;
        for object in results {
            if object["StatusId"] as? Int == 3 {
                sum3++
            }else if object["StatusId"] as? Int == 6 {
                sum6++
            }
        }
        
        return (sum3 - sum6)/Double(results.count)
    }
    
    func getRatingAsSeller() -> Double{
        let query = PFQuery(className: "Spot")
        query.whereKey("owner", equalTo: self)
        var results = [PFObject]()
        do{
            try results = query.findObjects()
        }catch{
            return 0.0
        }
        if results.count == 0 {
            return 0.0
        }
        var sum3 = 0.0, sum6 = 0.0;
        for object in results {
            if object["StatusId"] as? Int == 3 {
                sum3++
            }else if object["StatusId"] as? Int == 7 {
                sum6++
            }
        }
        
        return (sum3 - sum6)/Double(results.count)
    }
}

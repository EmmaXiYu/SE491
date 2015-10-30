//
//  spot.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 10/14/15.
//  Copyright © 2015 SE491. All rights reserved.
//

import Foundation

class Spot {
    var location : Location = Location()
    var type : String = ""
    var rate : Double = 0.0
    var timeLeft : Int = 0
    var minDonation = 0
    var legalTime = ""
    var timeToLeave : NSDate?
    var Owner: User = User()
}
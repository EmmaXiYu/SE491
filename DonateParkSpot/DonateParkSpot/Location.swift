//
//  Location.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 10/13/15.
//  Copyright © 2015 SE491. All rights reserved.
//

import Foundation
import Parse

class Location {
    var latitude : Double? = 0.0
    var longitude : Double? = 0.0
    var altitude : Double? = 0.0
    
    init(object: PFGeoPoint?){
        
        latitude = object?.latitude
        longitude = object?.longitude
        altitude = 0
    }
    
    init(){
        latitude = 0;
        longitude = 0;
        altitude = 0;
    }
}
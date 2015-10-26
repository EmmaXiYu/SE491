//
//  CustomerAnnotation.swift
//  DonateParkSpot
//
//  Created by Apple on 10/24/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import MapKit
import Parse



class CustomerAnnotation: NSObject, MKAnnotation {

    
    var  coordinate : CLLocationCoordinate2D
 
    
    init(coordinate : CLLocationCoordinate2D) {
        
        self.coordinate = coordinate
        
    }
    
    
    
    
}

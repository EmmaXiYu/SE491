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
    
    var title : String!
    var subtitle : String!
    var spot = Spot()
    
    let  coordinate : CLLocationCoordinate2D
    
    
    
    
    init(coordinate : CLLocationCoordinate2D, spotObject : Spot) {
        self.coordinate = coordinate
        spot = spotObject
        
        
        
        
    }
    
    
    
    
    
    
    
}

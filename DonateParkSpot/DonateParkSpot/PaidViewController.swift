//
//  PaidViewController.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 3/8/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class PaidViewController : UIViewController {
    
    func showNavigation(){
        let coordinate = CLLocationCoordinate2DMake(16.775, -3.009);
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil);
        let mapItem = MKMapItem(placemark: placemark);
        mapItem.name = "My Place";
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        let launchOptions = [MKLaunchOptionsDirectionsModeKey :  MKLaunchOptionsDirectionsModeDriving];
        // Get the "Current User Location" MKMapItem
        let currentLocationMapItem = MKMapItem.mapItemForCurrentLocation();
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        MKMapItem.openMapsWithItems([currentLocationMapItem, mapItem], launchOptions: launchOptions)
    }
}
//
//  MapController.swift
//  DonateParkSpot
//
//  Created by Xiaoyu Yuan on 10/12/15.
//  Copyright © 2015 SE491. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
   let locationManager = CLLocationManager()
    var latitude: Double=0
    var longitude: Double=0
    
   @IBOutlet weak var mapView: MKMapView!
       override func viewDidLoad() {
        super.viewDidLoad()
        //let initialLocation = CLLocation(latitude: 41.7958333, longitude: -87.9755556)
       let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    
    @IBAction func AddSpot(sender: AnyObject) {
   
       // let location = self.locationManager.location
        var locLongitude=longitude   //TODO: Use it to populate the model
        var loc_latitude=latitude    //TODO: Use it to populate the model
        var test=loc_latitude
          }

    
    let regionRadius: CLLocationDistance = 20000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as? CLLocation?
        let center = CLLocationCoordinate2D(latitude: location!!.coordinate.latitude, longitude: location!!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        // Add an annotation on Map View
        let point: MKPointAnnotation! = MKPointAnnotation()
        
        point.coordinate = location!!.coordinate
        point.title = "Current Location"
        point.subtitle = "sub title"
        
        self.mapView.addAnnotation(point)
           
            
        latitude = location!!.coordinate.latitude
        longitude = location!!.coordinate.longitude

        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
    }


    
    
    

}
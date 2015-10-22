//
//  MapViewController.swift
//  DonatingParkingSpotE
//
//  Created by Apple on 10/19/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    let locationManager=CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.locationManager.delegate=self
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    //location delegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last
        let center=CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude:location!.coordinate.longitude)
        let region=MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        
        
    }

    
    
}

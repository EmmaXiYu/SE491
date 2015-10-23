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

class MapController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate ,UISearchBarDelegate{
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
        
    }
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


    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }

}
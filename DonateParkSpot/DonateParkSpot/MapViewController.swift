//
//  MapViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 10/23/15.
//  Copyright © 2015 Apple. All rights reserved.
//Just TEst
//

import UIKit
import MapKit
import CoreLocation
import Parse

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    var address = ""
    var latitude = Double ()
    var longitude = Double ()
    var ojId =  String()
    var searchingLatitude = Double()
    var searchingLongitude = Double()

   let locationManager=CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        self.locationManager.delegate=self
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation=true
        self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
        
    }
  
    @IBAction func showMenu() {
        menu.hidden = !menu.hidden
    }
    
    
    //location delegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        //let location = locations.last
        //let center=CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude:location!.coordinate.longitude)
        //let region=MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
        //self.mapView.setRegion(region, animated: true)
        //self.locationManager.stopUpdatingLocation()
        if locationManager.location != nil {
            latitude = locationManager.location!.coordinate.latitude
            longitude = locationManager.location!.coordinate.longitude
            //mapView.camera.centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        
        
        super.didReceiveMemoryWarning()
    }
    

    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!)
    {
        if (segue.identifier == "SpotView")
        {
            
            let spotView = segue!.destinationViewController as! SpotDetailViewController
            
            
            spotView.latitudeD = latitude
            spotView.longitudeD = longitude
            

            }
            
    
    }
 
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        
        NSUserDefaults.standardUserDefaults().synchronize();
        self.dismissViewControllerAnimated(true, completion: nil);
        

    }
    
    
     func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        address = searchBar.text!;
        
        let user = PFUser.currentUser()
        
        let search = PFObject(className: "SearchHistory")
        search["user"] = user!
        search["address"] = address
        
        search.saveInBackgroundWithBlock { (success, error) -> Void in
            print(success)
            print(error)
            
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if placemarks!.count > 0 {
                
                let placemark = placemarks!.first as CLPlacemark!
                let location = placemark.location
                let coordinate = location!.coordinate
                self.searchingLatitude = coordinate.latitude
                self.searchingLongitude = coordinate.longitude
                
                
                let geoPoint = PFGeoPoint(latitude: coordinate.latitude ,longitude: coordinate.longitude  );
                //let spot = PFObject(className: "Spot")
                var query: PFQuery = PFQuery()
                query = PFQuery(className: "Spot")
                query.whereKey("SpotGeoPoint", nearGeoPoint: geoPoint, withinMiles: 20)
                query.findObjectsInBackgroundWithBlock {
                    (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        for object in objects! {
                          
                            let pin = object["SpotGeoPoint"] as! PFGeoPoint
                            let pinLatitude: CLLocationDegrees = pin.latitude
                            let pinLongtitude: CLLocationDegrees = pin.longitude
                            
                            let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: pinLatitude, longitude: pinLongtitude)
                            
                             let annotation = CustomerAnnotation(coordinate: pinLocation)
                            self.mapView.addAnnotation(annotation)
                            
                            
                        
                        }
                    }
                    
                }
    }
            
            
            
        })
        
        
      
        
    
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.text=""
        
    
    }
    
    
    
    
    
   }
    
   
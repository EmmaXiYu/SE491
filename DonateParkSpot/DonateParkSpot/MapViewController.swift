//
//  MapViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 10/23/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    
    /* @IBAction func logoutButtonTapped(sender: AnyObject) {
    
    
    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
    
    NSUserDefaults.standardUserDefaults().synchronize();
    self.dismissViewControllerAnimated(true, completion: nil);
    }*/
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func DetailButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("SpotView", sender: self)}
    
    
    var address = ""
    var latitude = Double ()
    var longitude = Double ()
    var ojId =  String()
    var searchingLatitude = Double()
    var searchingLongitude = Double()
    var spotO = Spot()
    
    
    let locationManager=CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        self.locationManager.delegate=self
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation=true
        self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        searchBar.delegate = self
        mapView.delegate = self
        
        
    }
    
    
    
    //location delegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last
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
        
        if segue.identifier == "SpotDetailClientClicked"
            
        {
            
            let seeDetailToBuy = segue!.destinationViewController as!  BuyDetailController
            
            
            
            
            
            
            
            
        }
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        address = searchBar.text!;
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if placemarks!.count > 0 {
                
                let placemark = placemarks!.first as CLPlacemark!
                let location = placemark.location
                let coordinate = location!.coordinate
                self.searchingLatitude = coordinate.latitude
                self.searchingLongitude = coordinate.longitude
                self.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                let geoPoint = PFGeoPoint(latitude: coordinate.latitude ,longitude: coordinate.longitude  );
                //let spot = PFObject(className: "Spot")
                var query: PFQuery = PFQuery()
                query = PFQuery(className: "Spot")
                query.whereKey("SpotGeoPoint", nearGeoPoint: geoPoint, withinMiles: 20)
                query.findObjectsInBackgroundWithBlock {(objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        for object in objects! {
                            let spotObject = Spot()
                            let pin = object["SpotGeoPoint"] as! PFGeoPoint
                            let pinLatitude: CLLocationDegrees = pin.latitude
                            let pinLongtitude: CLLocationDegrees = pin.longitude
                            let userName = object["owner"] as! String
                            
                            let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: pinLatitude, longitude: pinLongtitude)
                            spotObject.owner.username = userName
                            spotObject.location.latitude = pinLatitude
                            spotObject.location.longitude = pinLongtitude
                            let annotation = CustomerAnnotation(coordinate: pinLocation,spotObject: spotObject)
                            
                            annotation.spot = spotObject
                            
                            annotation.title = userName
                            annotation.subtitle = "Rating bar here"
                            self.mapView.addAnnotation(annotation)
                            
                            
                            
                            
                        }
                    }
                    
                }
            }
            
            
            
        })
        
        
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
    }
    
    
    
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation
        ) -> MKAnnotationView!{
            
            
            if annotation is CustomerAnnotation {
                let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.draggable = true
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.animatesDrop = true
                pinAnnotationView.pinColor = MKPinAnnotationColor.Purple
                
                let btn = UIButton(type: .DetailDisclosure)
                pinAnnotationView.rightCalloutAccessoryView = btn
                let pic = UIImageView (image: UIImage(named: "test.png"))
                pinAnnotationView.leftCalloutAccessoryView = pic
                
                
                return pinAnnotationView
                
            }
            
            return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        /*if let annotation = view.annotation as? CustomerAnnotation {
        mapView.removeAnnotation(annotation)
        }*/
        let name = "Emma@gmail.com"
        
        
        
        let query = PFQuery(className: "Spot")
        
        query.whereKey("owner", equalTo : name)
        query.findObjectsInBackgroundWithBlock {(objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    let pin = object["SpotGeoPoint"] as! PFGeoPoint
                    let pinLatitude: CLLocationDegrees = pin.latitude
                    let pinLongtitude: CLLocationDegrees = pin.longitude
                    
                    self.spotO.location.latitude = pinLatitude
                    self.spotO.location.longitude = pinLongtitude
                    
                }
            }
            
        }
        if control == view.rightCalloutAccessoryView {
            print("Disclosure Pressed!")
            performSegueWithIdentifier("SpotDetailClientClicked", sender: self)
        }
        
    }
    
}

   
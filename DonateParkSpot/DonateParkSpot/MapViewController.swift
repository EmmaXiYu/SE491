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
import QuartzCore

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var Menu: UIBarButtonItem!

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func DetailButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("SpotView", sender: self)}
    
    @IBOutlet weak var historyView: UITableView!
    
    var address = ""
    var latitude = Double ()
    var longitude = Double ()
    var ojId =  String()
    var searchingLatitude = Double()
    var searchingLongitude = Double()
    var spotO = Spot()
    var filtered:[String] = []
    var history:[String] = [" "]
    var searchActive: Bool = false
    var ownerName:String = ""
    var ownerId:String = ""
    
    let locationManager=CLLocationManager()
    
    @IBOutlet weak var addSpot: UIButton!
    @IBOutlet weak var currentPosition: UIButton!
    
    var spots = [Spot]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        self.title = "Parking Spots"
        self.locationManager.delegate=self
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation=true
        self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        addSpot.layer.masksToBounds = false
        addSpot.layer.borderColor = UIColor.whiteColor().CGColor
        addSpot.layer.cornerRadius = 15
        addSpot.clipsToBounds = true
        
        currentPosition.layer.masksToBounds = false
        currentPosition.layer.borderColor = UIColor.whiteColor().CGColor
        currentPosition.layer.cornerRadius = 15
        currentPosition.clipsToBounds = true
        
        searchBar.delegate = self
        mapView.delegate = self
        historyView.delegate = self
        historyView.dataSource = self
        searchBar.delegate = self
        historyView.hidden = true
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "SearchHistory")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {(objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let historyResult = object["address"] as! String
                    self.history.append(historyResult)
                    
                }
            }
        }
        self.addPlaceHodlerText()

    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
        historyView.hidden = false
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchActive = false
        historyView.hidden = true
    }
    
    @IBAction func goToCurrentPosition() {
        if locationManager.location != nil {
            mapView.setCenterCoordinate(locationManager.location!.coordinate, animated: true)
            mapView.userTrackingMode = .FollowWithHeading
        }
    }
    
    //location delegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationManager.location != nil {
            latitude = locationManager.location!.coordinate.latitude
            longitude = locationManager.location!.coordinate.longitude
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!)
    {
        if (segue.identifier == "AddSpot")
        {
            let spotView = segue!.destinationViewController as! SpotDetailViewController
            spotView.latitudeD = latitude
            spotView.longitudeD = longitude
       }
        
       if segue.identifier == "SpotDetailClientClicked"
            
        {
            var selectedAnnotation: MKAnnotation = self.mapView.selectedAnnotations[0] as MKAnnotation
            let cAnnotation: CustomerAnnotation = selectedAnnotation as! CustomerAnnotation
            let seeDetailToBuy = segue!.destinationViewController as!  BuyDetailController
            seeDetailToBuy.spot = cAnnotation.spot
           // seeDetailToBuy.ownerName = ownerName
            //seeDetailToBuy.ownerId = ownerId
        }
    }
   
    func addPlaceHodlerText() -> Void
    {
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.attributedPlaceholder =  NSAttributedString(string:NSLocalizedString("type a address to search a parking spot", comment:""),
                        attributes:[NSForegroundColorAttributeName: UIColor.orangeColor()])
                }
            }
        }
    
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = true
        searchBar.resignFirstResponder()
        self.address = searchBar.text!;
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if placemarks?.count > 0 {
                let search = PFObject(className: "SearchHistory")
                let placemark = placemarks!.first as CLPlacemark!
                let location = placemark.location
                let coordinate = location!.coordinate
                self.searchingLatitude = coordinate.latitude
                self.searchingLongitude = coordinate.longitude
                let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                let ifFound  = self.history.contains(placemark.name!);
                if ifFound == false{
                    search["address"] = placemark.name!
                        search["user"] = PFUser.currentUser()
                    search.saveInBackground()
                    self.history.append(placemark.name!)
                }
                
                
                self.mapView.centerCoordinate = center
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapView.setRegion(region, animated: true)
                
                var radium = PFUser.currentUser()!["SearchRadium"] as? String
                var radiumDouble : Double
                if radium == nil
                {
                    radiumDouble = 1
                    
                    let user = PFUser.currentUser()
                    
                    user!["SearchRadium"] = "1"
                    user!.saveInBackgroundWithBlock({
                        
                        (success: Bool, error: NSError?) -> Void in
                        
                    })
                    

                    
                    
                    }
                else {
                    radiumDouble = Double (radium!)!
                }
              
                let geoPoint = PFGeoPoint(latitude: coordinate.latitude ,longitude: coordinate.longitude  );
                var query: PFQuery = PFQuery()
                query = PFQuery(className: "Spot")
                query.whereKey("SpotGeoPoint", nearGeoPoint: geoPoint, withinMiles: radiumDouble)
                query.findObjectsInBackgroundWithBlock {(objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        for object in objects! {
                            let timeToLeave = object["leavingTime"] as! NSDate?
                            if timeToLeave?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                                
                                let spotObject = Spot()
                                let pin = object["SpotGeoPoint"] as? PFGeoPoint
                                let pinLatitude: CLLocationDegrees = pin!.latitude
                                let pinLongtitude: CLLocationDegrees = pin!.longitude
                                let address = object["addressText"] as? String
                                let id = object.objectId
                                self.ownerId = id!
                                let type = object["type"] as? Int
                                let rate = object["rate"] as? Double
                                let timeLeft = object["timeLeft"] as? Int
                                let miniDonation = object["minimumPrice"] as? Int
                                let legalTime = object["legalTime"] as? String
                                let timeToLeave = object["leavingTime"] as! NSDate?
                                let ownerName = object["owner"] as! String
                                self.ownerName=ownerName
                                let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: pinLatitude, longitude: pinLongtitude)
                                //spotObject.owner.username = ownerName
                                spotObject.location.latitude = pinLatitude
                                spotObject.location.longitude = pinLongtitude
                                spotObject.AddressText = address
                                spotObject.spotId = id!
                                spotObject.type = type
                                spotObject.rate = rate
                                spotObject.timeLeft = timeLeft
                                spotObject.minDonation = miniDonation
                                spotObject.legalTime = legalTime
                                spotObject.timeToLeave = timeToLeave
                                //  spotObject.owner = owner
                                //var subtitle = "Rating Bar Here"
                                let annotation = CustomerAnnotation(coordinate: pinLocation,spotObject: spotObject, title :ownerName, subtitle: id!)
                                annotation.spot = spotObject
                                //annotation.subtitle = "Rating bar here"
                                self.mapView.addAnnotation(annotation)
                            }
                        }
                    }
                    
                }
            }
            
            
            
        })
                historyView.hidden = true
        
        
    }
    
    func searchForNewSpots(){
        let coordinate = mapView.centerCoordinate
        let geoPoint = PFGeoPoint(latitude: coordinate.latitude ,longitude: coordinate.longitude  );
        var query: PFQuery = PFQuery()
        query = PFQuery(className: "Spot")
        query.whereKey("SpotGeoPoint", nearGeoPoint: geoPoint, withinMiles: 20)
        query.findObjectsInBackgroundWithBlock {(objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let timeToLeave = object["leavingTime"] as! NSDate?
                    
                    if timeToLeave?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                        
                        let spotObject = Spot()
                        let pin = object["SpotGeoPoint"] as? PFGeoPoint
                        spotObject.location.latitude = pin!.latitude
                        spotObject.location.longitude = pin!.longitude
                        spotObject.AddressText = object["addressText"] as? String
                        spotObject.spotId = object.objectId!
                        self.ownerId = object.objectId!
                        spotObject.type = object["type"] as? Int
                        spotObject.rate = object["rate"] as? Double
                        spotObject.timeLeft = object["timeLeft"] as? Int
                        spotObject.minDonation = object["minimumPrice"] as? Int
                        spotObject.legalTime = object["legalTime"] as? String
                        spotObject.timeToLeave = object["leavingTime"] as! NSDate?
                        spotObject.ownerName = object["owner"] as? String
                        self.addNewSpot(spotObject)
                    }
                }
            }
            
        }
    }
    
    func addNewSpot(spot: Spot){
        for s in spots {
            if s.location.latitude == spot.location.latitude && spot.location.longitude == s.location.longitude {
                return
            }
        }
        spots.append(spot)
        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: spot.location.latitude, longitude: spot.location.longitude)
        
        let annotation = CustomerAnnotation(coordinate: pinLocation,spotObject: spot, title :spot.ownerName!, subtitle: spot.spotId)
        annotation.spot = spot
        //annotation.subtitle = "Rating bar here"
        self.mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        searchForNewSpots()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchActive = false
        historyView.hidden = true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation
        ) -> MKAnnotationView!{
            
            
            if let a = annotation as? CustomerAnnotation {
                let pinAnnotationView = MKPinAnnotationView(annotation: a, reuseIdentifier: "myPin")
                let ownerID:String = a.subtitle!
                let name = a.title!
                let pic = UIImageView (image: UIImage(named: "test.png"))
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.draggable = false
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.animatesDrop = true
                pinAnnotationView.pinColor = MKPinAnnotationColor.Purple
                
                
                let query = PFUser.query()
                
                do{ let user = try query!.getObjectWithId(ownerID) as! PFUser
                    if let userPicture = user["Image"] as? PFFile {
                        userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                pic.image = UIImage(data:imageData!)
                            }
                        }
                    }

                    
                
                
                }
                catch{
                    //Throw exception here
                }
                let btn = UIButton(type: .DetailDisclosure)
                pinAnnotationView.rightCalloutAccessoryView = btn
                pic.frame = CGRectMake(0, 0, 40, 40);
                pinAnnotationView.leftCalloutAccessoryView = pic
                pinAnnotationView.frame = CGRectMake(0,0,500,500)
                return pinAnnotationView
                
            }
            
            return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            print("Disclosure Pressed!")
            self.performSegueWithIdentifier("SpotDetailClientClicked", sender: self)
            
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = history.filter({ (text) -> Bool in
            let tmp:NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
            
        })
        if(filtered.count == 0){
            searchActive = false;
        }
        else{
            searchActive = true;
        }
        self.historyView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            print("Count:" + filtered.count.description)
            return filtered.count
        }
        return (filtered.count - filtered.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell = self.historyView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell;
        
        if(searchActive){
            cell.textLabel!.text = filtered[indexPath.row]
        }
        else{
            cell.textLabel!.text = history[indexPath.row]
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell  = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell?
        searchBar.text = (currentCell?.textLabel?.text!)!
    }
    
    
}

   
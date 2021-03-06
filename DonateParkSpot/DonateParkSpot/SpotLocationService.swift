//
//  SpotLocationService.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 1/23/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation
import Parse
import CoreLocation
class DonateSpotUserSession
{
 static var IsHaveCurrentActiveBid = false
 static var ActiveBid : Bid? = nil
 static var isLocationManagerIntited = false;
}

class SpotLocationService: NSObject,CLLocationManagerDelegate{
    var latitude = Double ()
    var longitude = Double ()
    let locationManager=CLLocationManager()
    //var isLocationManagerIntited = false;
    /*
    SUMMARY :Background Location tracking
    
    Have global property as IsHaveCurrentActiveBid: This Property indicate if this user have paid Bid in last 12 hours which is not closed
    By default false. Update this property in two place:
    On application start check by running this query in Parse server
    Set it to true immediately after user makes the payment
    
    If this property id true than only track location in back ground
    
    */
   
    
    func getTimeForHourEarlierFromNow(HoursFromNow : Int) -> NSDate
    {
        let components: NSDateComponents = NSDateComponents()
        components.setValue(-HoursFromNow, forComponent: NSCalendarUnit.Hour);
        let date: NSDate = NSDate()
        let EarlierFromNow = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        
        return EarlierFromNow!
    }
    
    func IsUserHaveActivePaidBid() -> Void
    {
        if(PFUser.currentUser() != nil)
        {
            var bi: Bid? = nil
            let EarlierFromNow =  self.getTimeForHourEarlierFromNow(12)
            // Get the time 12 hours from now
            let currentUser = PFUser.currentUser()
            let query = PFQuery(className:"Bid") // table name is score
            query.whereKey("PaymentMakeTime", greaterThanOrEqualTo: EarlierFromNow)
            query.whereKey("StatusId", equalTo: 3) //StatusId 3 Means Donetion Recieved and closed
            // We will track location after the payment recieved only
            query.whereKey("UserId", equalTo:(currentUser?.email)!)
            query.includeKey("spot")
            print("Searing Bid with Status 3,PaymentMakeTime after: \(EarlierFromNow) ][for user: \(currentUser?.email)!)]")
            query.findObjectsInBackgroundWithBlock {
                (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        if(objects?.count>0)
                        {
                        for object in objects! {
                            bi = Bid(object: object)
                            
                        }
                            DonateSpotUserSession.IsHaveCurrentActiveBid = true
                            DonateSpotUserSession.ActiveBid = bi
                            print("returning true from IsHaveCurrentActiveBid")
                           
                            self.initLocationManager()
                           
                        }
                        else
                        {
                            print("NO Active bid to location Track. [for user: \(currentUser?.email!)]")
                        }
                }
            }
        
        }
    }
    
    
    
    func initLocationManager() {
        // This func will call at regular interval. Need to init the locationManager only once
        if(DonateSpotUserSession.isLocationManagerIntited == false)
        {
            self.locationManager.delegate = self
            
            //self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
           
           // self.locationManager.startMonitoringSignificantLocationChanges()
           self.locationManager.startUpdatingLocation()
            
            DonateSpotUserSession.isLocationManagerIntited = true
            print("Started location Tracking")
        }
    }
    
    //TODO: This function not is use currently. May need to use . Consult Artitect
    func sendBackgroundLocationToServer(location: CLLocation) {
        var bgTask = UIBackgroundTaskIdentifier()
        bgTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(bgTask)
        }
        
        print(location.coordinate.latitude)
        
        if (bgTask != UIBackgroundTaskInvalid)
        {
            UIApplication.sharedApplication().endBackgroundTask(bgTask);
            bgTask = UIBackgroundTaskInvalid;
        }
    }
   
    
     func Getlocation() -> Void{
        if locationManager.location != nil {
            latitude = locationManager.location!.coordinate.latitude
            longitude = locationManager.location!.coordinate.longitude
            print("latitude\(latitude) longitude \(longitude)")
            if(DonateSpotUserSession.ActiveBid != nil)
            {
                let spot = DonateSpotUserSession.ActiveBid?.spot
                
                let SpotLocation = CLLocation(latitude: (spot?.location.latitude)!, longitude: (spot?.location.longitude)!)
                let distanceBetweenMeter: CLLocationDistance = locationManager.location!.distanceFromLocation( SpotLocation)
                
                if(distanceBetweenMeter > 1000)
                {
                    // Show in Mile
                     print("\(distanceBetweenMeter/1609.34) Mile Away")
                    
                }
                else if (distanceBetweenMeter > 0 && distanceBetweenMeter < 1000)
                {
                    // Show in meter
                    print("\(distanceBetweenMeter) Meter Away")
                }
            }
            // TODO : Save to server
            //self.sendBackgroundLocationToServer(locations[0]);
        }
    }

    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationManager.location != nil {
            latitude = locationManager.location!.coordinate.latitude
            longitude = locationManager.location!.coordinate.longitude
            print("latitude\(latitude) longitude \(longitude)")
            /*NOT WORKING*/
            if(DonateSpotUserSession.ActiveBid != nil)
            {
                let spot = DonateSpotUserSession.ActiveBid?.spot
           
                let SpotLocation = CLLocation(latitude: (spot?.location.latitude)!, longitude: (spot?.location.longitude)!)
                let distanceBetween: CLLocationDistance = locationManager.location!.distanceFromLocation( SpotLocation)
                print("distanceBetween\(distanceBetween) ")
            }
            // TODO : Save to server
            //self.sendBackgroundLocationToServer(locations[0]);
        }
    }
    
    
}
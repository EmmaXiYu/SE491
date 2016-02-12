//
//  SpotDetailNextViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 2/10/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Parse


class SpotDetailNextViewController: UIViewController {
    
    var spotObject = Spot()
    var addressIndicator = String ()
    var currentAddress = String()
    
    @IBOutlet weak var instructionTextField: UILabel!
    
    @IBOutlet weak var CurrentAddressTextField: UILabel!
    
    @IBOutlet weak var anotherAddress: UITextField!
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        if addressIndicator == "Current Address"
        {
            
            anotherAddress.hidden = true
           CurrentAddressTextField.text = currentAddress
            instructionTextField.text = "Please check your current address:"
          
            
        }
        else if addressIndicator == "Another Address"
            
        {
            CurrentAddressTextField.hidden = true
         instructionTextField.text = "Please Enter Your Spot Address:"
            
            
        }
    
    
    }
    
    @IBAction func SubmitTapped(sender: AnyObject) {
        
        if addressIndicator == "Another Address"{
           // let address = "243 South Wabash Avenue Chicago, IL 60604"
      
    /*CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if (error != nil) {
                    print("Error \(error!)")
                } else  {
                    if placemarks?.count > 0 {
                        let placemark = placemarks![0]as CLPlacemark!
                        let location = placemark.location
                        let coordinate = location!.coordinate
                        let latitudeD = coordinate.latitude
                        let longitudeD = coordinate.longitude
                        let geoPoint = PFGeoPoint(latitude: latitudeD ,longitude: longitudeD);
                        self.spotObject.location = Location.init(object: geoPoint)
                        self.spotObject.addressText = self.anotherAddress.text!
                    }
                }
            })*/
            
            
             let address = anotherAddress.text!
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
                if placemarks?.count > 0 {
                   
                    
                    let placemark = placemarks![0]as CLPlacemark!
                    let location = placemark.location
                    let coordinate = location!.coordinate
                    let latitudeD = coordinate.latitude
                    let longitudeD = coordinate.longitude
                    let geoPoint = PFGeoPoint(latitude: latitudeD ,longitude: longitudeD);
                    self.spotObject.location = Location.init(object: geoPoint)
                    self.spotObject.addressText = self.anotherAddress.text!

                    }
                
                    
                    
                  
                
                
            })

            
            
        }
        let spotPFObject = PFObject(className: "Spot")
        spotPFObject["SpotGeoPoint"] = PFGeoPoint(latitude: spotObject.location.latitude!, longitude:  spotObject.location.longitude!)
        spotPFObject["type"] = spotObject.type
        spotPFObject["rate"] = spotObject.rate
        spotPFObject["timeLeft"] = spotObject.timeLeft
        spotPFObject["minimumPrice"] = spotObject.minDonation
        spotPFObject["leavingTime"] = spotObject.timeToLeave
        spotPFObject["owner"] = spotObject.owner
        spotPFObject["addressText"] = spotObject.addressText
        spotPFObject["legalTime"] = spotObject.legalTime
    
        spotPFObject.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if (error == nil){
                self.dismissViewControllerAnimated(true, completion: nil);
                
            }else{
                print(error)
            }
        }
    let installation = PFInstallation.currentInstallation()
       installation["SpotOwner"] = spotObject.owner
       installation.saveInBackground()
    }
    /*
    testObject.saveInBackgroundWithBlock { (success, error) -> Void in
    
    if (error == nil){
    self.dismissViewControllerAnimated(true, completion: nil);
    
    }else{
    }
    }
    let installation = PFInstallation.currentInstallation()
    installation["SpotOwner"] = testObject["owner"] as! PFUser
    installation.saveInBackground()*/


}
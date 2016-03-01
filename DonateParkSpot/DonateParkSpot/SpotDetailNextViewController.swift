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
    
    var addressIndicator = String ()
    var currentAddress = String()
    var location : Location = Location()
    var type : Int = 0
    var rate : Double = 0.0
    var timeLeft : Double = 0
    var minDonation : Double = 0
    var legalTime : String = ""
    var timeToLeave : NSDate?
    var owner : PFUser?
    var addressText: String = ""
    var statusId : Int = -1 // 1: Active and open for bid; 2 : bid Accepted; 3: Donetion Recieved and closed 4: Rejected
    var spotObject = PFObject(className:"Spot")
    
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
            spotObject["SpotGeoPoint"] = PFGeoPoint(latitude: location.latitude!, longitude: location.longitude!)
            spotObject["addressText"] = currentAddress
          
            
        }
        else if addressIndicator == "Another Address"
            
        {
            CurrentAddressTextField.hidden = true
            instructionTextField.text = "Please Enter Your Spot Address:"
                        anotherAddress.hidden = false
            
            
        }
        spotObject["type"] = type
        spotObject["rate"] = rate
        spotObject["timeLeft"] = timeLeft
        spotObject["minimumPrice"] = minDonation
        spotObject["leavingTime"] = timeToLeave == nil ? NSNull() : timeToLeave
        spotObject["owner"] = owner == nil ? NSNull() : owner
        spotObject["StatusId"] = statusId
        spotObject["legalTime"] = legalTime
 
        
        
        

    }
    
    @IBAction func SubmitTapped(sender: AnyObject) {
        
        if addressIndicator == "Another Address"{
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
                    self.spotObject.toPFObject().saveInBackground()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            })
        }else{
            self.spotObject.toPFObject().saveInBackground()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        let installation = PFInstallation.currentInstallation()
        installation["SpotOwner"] = owner
        installation.saveInBackground()
        self.dismissViewControllerAnimated(true, completion: nil);
    }


}
//
//  SpotDetailViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 10/24/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse


class SpotDetailViewController: UIViewController {
    
   
    
    @IBOutlet weak var timeToLeaveTextField: UITextField!
    
    
    @IBOutlet weak var minimumDonatePrice: UITextField!
    
    var id = String();
    var latitudeD = Double()
    var longitudeD = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
    @IBAction func submitTapped(sender: AnyObject) {
    
     
        
        let geoPoint = PFGeoPoint(latitude: latitudeD ,longitude: longitudeD);
        
        
        
        
        let testObject = PFObject(className: "Spot")
        testObject["SpotGeoPoint"] = geoPoint
        testObject["leavingTime"] = timeToLeaveTextField.text
        testObject["minimumPrice"] = Float(minimumDonatePrice.text!)
        testObject["owner"] = PFUser.currentUser()!.username
        
        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
            
        if (error == nil)
            {
                
                //let annotation = CustomerAnnotation(coordinate: (self.locationManager.location?.coordinate)!)
                
               // self.mapView.addAnnotation(annotation)
                
                
            }
        }

        self.dismissViewControllerAnimated(true, completion: nil);
    
    }
    
    
//    func prepareForSegueSpotDetailClientClicked(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier=="SpotView"){
//            _ = segue.destinationViewController as! MapViewController
//        }
//    }
    
    @IBAction func CancelButtonTapped(sender: AnyObject) {
//        self.performSegueWithIdentifier("SpotView", sender: nil)
    }
    
    

}

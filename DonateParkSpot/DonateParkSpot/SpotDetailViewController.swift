//
//  SpotDetailViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 10/24/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse


class SpotDetailViewController: UITableViewController {
    
   
    
    @IBOutlet weak var rate: UITextField!
    @IBOutlet weak var timeLeft: UITextField!
    @IBOutlet weak var timeToLeaveTextField: UITextField!
    @IBOutlet weak var info: UITextField!
    @IBOutlet weak var minimumDonatePrice: UITextField!
    @IBOutlet weak var type: UISegmentedControl!
    
    var id = String();
    var latitudeD = Double()
    var longitudeD = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rate.text = "0.00"
        rate.enabled = false
        timeLeft.text = "0"
        timeLeft.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func changeType(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            rate.text = "0.00"
            rate.enabled = false
            timeLeft.text = "0"
            timeLeft.enabled = false
        }else{
            rate.text = ""
            rate.enabled = true
            timeLeft.text = ""
            timeLeft.enabled = true
        }
    }
    
    
    @IBAction func submitTapped(sender: AnyObject) {
    
     
        
        let geoPoint = PFGeoPoint(latitude: latitudeD ,longitude: longitudeD);
        
        
        
        
        let testObject = PFObject(className: "Spot")
        testObject["SpotGeoPoint"] = geoPoint
        //testObject["leavingTime"] = timeToLeaveTextField.text
        testObject["minimumPrice"] = Float(minimumDonatePrice.text!)
        testObject["owner"] = PFUser.currentUser()!.username
        testObject["rate"] = Double(rate.text!)
        testObject["timeLeft"] = Int(timeLeft.text!)
        testObject["info"] = info.text
        testObject["type"] = type.selectedSegmentIndex
        
        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
            
        if (error == nil)
            {
                
               // let annotation = CustomerAnnotation(coordinate: (self.locationManager.location?.coordinate)!)
                
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

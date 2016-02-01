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
    var timePickerView  : UIDatePicker = UIDatePicker()
    
    var id = String();
    var latitudeD = Double()
    var longitudeD = Double()
    var addressText = ""
    
    
    override func viewDidLoad() {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitudeD, longitude: longitudeD)
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            self.addressText = placemarks![0].name!
        })
        super.viewDidLoad()
        rate.text = "0.00"
        rate.enabled = false
        timeLeft.text = "0"
        timeLeft.enabled = false
        
        
        let currentDate = NSDate()  //5 -  get the current date
        //timePickerView.minimumDate = currentDate  //6- set the current date/time as a minimum
        timePickerView.date = currentDate //7
        timePickerView.datePickerMode = UIDatePickerMode.Time
    
        timeToLeaveTextField.inputView = timePickerView
        timePickerView.addTarget(self, action: Selector("handleTimePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        handleTimePicker(timePickerView)
        
    }
    
    @IBAction func userDOBSelectedAction(sender: UITextField) {
        timeToLeaveTextField.resignFirstResponder()
    }
    
    func handleTimePicker(sender: UIDatePicker) {
        var timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        timeToLeaveTextField.text = timeFormatter.stringFromDate(sender.date)
        timeToLeaveTextField.resignFirstResponder()
        
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
        if timePickerView.date.compare(NSDate()) == NSComparisonResult.OrderedAscending{
            testObject["leavingTime"] = timePickerView.date.dateByAddingTimeInterval(86400)
        } else {
            testObject["leavingTime"] = timePickerView.date
        }
        testObject["minimumPrice"] = Float(minimumDonatePrice.text!)
        testObject["owner"] = PFUser.currentUser()!.username
        testObject["OwnerID"] = PFUser.currentUser()!.objectId
        testObject["rate"] = Double(rate.text!)
        testObject["timeLeft"] = Int(timeLeft.text!)
        testObject["legalTime"] = info.text
        testObject["type"] = type.selectedSegmentIndex
        testObject["addressText"] = addressText

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

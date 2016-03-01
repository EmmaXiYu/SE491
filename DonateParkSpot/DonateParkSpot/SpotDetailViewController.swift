//
//  SpotDetailViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 10/24/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse


class SpotDetailViewController: UITableViewController, UIPickerViewDelegate,
    UIPickerViewDataSource
{
    
   
    
    @IBOutlet weak var rate: UITextField!
    @IBOutlet weak var timeLeft: UITextField!
    @IBOutlet weak var timeToLeaveTextField: UITextField!
    @IBOutlet weak var info: UITextField!
    @IBOutlet weak var minimumDonatePrice: UITextField!
    @IBOutlet weak var type: UISegmentedControl!
    
    
    @IBOutlet weak var AddressTextField: UITextField!
    
    var timePickerView  : UIDatePicker = UIDatePicker()
    
    var id = String();
    var latitudeD = Double()
    var longitudeD = Double()
    var addressText = ""
    var data = ["Current Address", "Another Address"]
    var picker = UIPickerView ()
    var currentAddress = ""
    let testObject = PFObject(className: "Spot")
    var timeToLeave : NSDate?
    //var currentSpot = Spot()
    
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
        data = ["Current Address", "Another Address"]

        
        
        let currentDate = NSDate()  //5 -  get the current date
        //timePickerView.minimumDate = currentDate  //6- set the current date/time as a minimum
        timePickerView.date = currentDate //7
        timePickerView.datePickerMode = UIDatePickerMode.Time
    
        timeToLeaveTextField.inputView = timePickerView
        timePickerView.addTarget(self, action: Selector("handleTimePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        handleTimePicker(timePickerView)
        
    }
    
    
   
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
 
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return data.count
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        AddressTextField.text = data [row]
     AddressTextField.resignFirstResponder()
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return  data[row]
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
        var minimumPrice: Float = 0
        if(minimumDonatePrice.text != ""){
            minimumPrice = Float(minimumDonatePrice.text!)!
        }
        testObject["minimumPrice"] = minimumPrice
        testObject["owner"] = PFUser.currentUser()
        var rateValue:Double = 0
        if(rate.text != "" ){
            rateValue = Double(rate.text!)!
        }
        testObject["rate"] = rateValue
        var timeLeftValue:Double = 0
        if(timeLeft.text != "" ){
            timeLeftValue = Double(timeLeft.text!)!
        }
        testObject["timeLeft"] = timeLeftValue
        testObject["legalTime"] = info.text
        testObject["type"] = type.selectedSegmentIndex
        testObject["addressText"] = addressText
        
        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if (error == nil){
                self.dismissViewControllerAnimated(true, completion: nil);
                
            }else{
            }
        }
        
        let installation = PFInstallation.currentInstallation()
        installation["SpotOwner"] = testObject["owner"] as! PFUser
        installation.saveInBackground()
    
    }
}

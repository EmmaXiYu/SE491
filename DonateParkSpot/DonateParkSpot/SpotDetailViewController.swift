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
    var currentSpot = Spot()
    
    override func viewDidLoad() {
        picker.delegate = self
        picker.dataSource = self
        AddressTextField.inputView = picker 
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
        AddressTextField.text = data[0]
        
        
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
    
     

     
 
        
      performSegueWithIdentifier("spotDetailNext", sender: self)
        }
    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!)
    {
        
        if AddressTextField.text == "Current Address"
            
        {
            let geoPoint = PFGeoPoint(latitude: latitudeD ,longitude: longitudeD);
            let currentLocation = Location.init(object: geoPoint)
            currentSpot.location = currentLocation
            currentSpot.addressText = addressText
            
        }
        if timePickerView.date.compare(NSDate()) == NSComparisonResult.OrderedAscending{
            currentSpot.timeToLeave =  timePickerView.date.dateByAddingTimeInterval(86400)
            
        } else {
            currentSpot.timeToLeave = timePickerView.date
        }
        var minimumPrice: Float = 0
        if(minimumDonatePrice.text != ""){
            minimumPrice = Float(minimumDonatePrice.text!)!
            currentSpot.minDonation = Int(minimumDonatePrice.text!)!
        }
        currentSpot.minDonation = Int(minimumPrice)
        currentSpot.owner = PFUser.currentUser()
        var rateValue:Double = 0
        if(rate.text != "" ){
            rateValue = Double(rate.text!)!
            currentSpot.rate = Double(rate.text!)!
        }
        currentSpot.rate = rateValue
        var timeLeftValue:Double = 0
        if(timeLeft.text != "" ){
            timeLeftValue = Double(timeLeft.text!)!
            currentSpot.timeLeft = Int(timeLeft.text!)!
        }
        currentSpot.timeLeft = Int(timeLeftValue)
        currentSpot.legalTime = info.text!
        currentSpot.type = type.selectedSegmentIndex
        

        if (segue.identifier == "spotDetailNext")
        {
            let spotNextView = segue!.destinationViewController as! SpotDetailNextViewController
            spotNextView.spotObject = currentSpot
            spotNextView.addressIndicator = AddressTextField.text!
            spotNextView.currentAddress = addressText
        }
        
    }
    

        
    
    }
    

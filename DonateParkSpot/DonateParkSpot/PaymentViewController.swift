//
//  PaymentViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 3/5/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class PaymentViewController: UITableViewController,UIPickerViewDelegate,
UIPickerViewDataSource, UITextFieldDelegate{

    var spotID = String()
    
    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var expiration: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var billingAdress: UITextField!
    @IBOutlet weak var paymentDone: UIBarButtonItem!
    
    @IBOutlet weak var charityOrganization: UITextField!
    
    var data = ["A Child's Wish Association of America", "AARP Foundation", "Accion International",
        "Accuracy in Media","Action Against Hunger-USA"]
    var picker = UIPickerView ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charityOrganization.text = data[0]
        charityOrganization.inputView = picker
        picker.dataSource = self
        picker.delegate = self
        
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
        charityOrganization.text = data [row]
        charityOrganization.resignFirstResponder()
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  data[row]
    }

    
    @IBAction func payment(sender: AnyObject) {
        
        if(cardNumber == nil || ownerName == nil || expiration == nil || cvv == nil||billingAdress == nil)
        {
             self.displayMyAlertMessage("None of the field above can be empty");
        }
        
        
    }
    
    func displayMyAlertMessage(usermessage:String)
        
    {
        let myAlert=UIAlertController(title: "Alert", message:usermessage,
            preferredStyle: UIAlertControllerStyle.Alert);
        let okayAction=UIAlertAction(title: "Okay", style:UIAlertActionStyle.Default, handler:nil)
        myAlert.addAction(okayAction);
        self.presentViewController(myAlert, animated: true, completion: nil);
        
        
    }

    
    
    
}

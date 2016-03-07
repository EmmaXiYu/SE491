//
//  PaymentViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 3/5/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class PaymentViewController: UITableViewController {

    var spotID = String()
    
    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var expiration: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var billingAdress: UITextField!
    @IBOutlet weak var paymentDone: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

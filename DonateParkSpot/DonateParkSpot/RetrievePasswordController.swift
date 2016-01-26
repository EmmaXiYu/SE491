//
//  RetrievePasswordController.swift
//  DonateParkSpot
//
//  Created by Apple on 1/25/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Parse

class RetrievePasswordController: UIViewController {

    
    @IBOutlet weak var sentLink: UITextView!
    
    @IBOutlet weak var EmailText: UITextField!
    
    @IBAction func RetrievePassword(sender: AnyObject) {
        
        let emailAddress : String = EmailText.text!
        if emailAddress != ""
        {
        
        do {try  PFUser.requestPasswordResetForEmail(emailAddress)
            sentLink.text = "Reset password link has sent to your registed email. Please reset password."}
        catch
        {
           displayMyAlertMessage("You have to enter a valid email address");
        }
        }
        else
        {
            displayMyAlertMessage("You have to enter an email address");
}
        

    }
    
    func displayMyAlertMessage(usermessage:String)
        
    {
        
        let myAlert=UIAlertController(title: "Alert", message:usermessage,
            
            preferredStyle: UIAlertControllerStyle.Alert);
        
        let okayAction=UIAlertAction(title: "Okay", style:UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okayAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);}

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
}

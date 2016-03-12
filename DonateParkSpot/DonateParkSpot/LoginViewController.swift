//
//  LoginViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 10/23/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        userEmailTextField.delegate = self;
        userPasswordTextField.delegate = self;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == userEmailTextField {
            userPasswordTextField.becomeFirstResponder()
            return true
        }else if textField == userPasswordTextField{
            self.view.endEditing(true)
            return true;
        }
        return true;
    }



    @IBAction func LoginButtonTapped(sender: AnyObject) {
        
        
        
     Login()
    }
    
    
    func Login()
    {
        let user = PFUser()
        user.username = userEmailTextField.text!.lowercaseString
        user.password = userPasswordTextField.text!
        PFUser.logInWithUsernameInBackground(userEmailTextField.text!, password: userPasswordTextField.text!, block:  {
            (username : PFUser?, Error : NSError?) -> Void in
        
            
            if Error == nil{
                                 
                
               /* let loginUser = PFUser.currentUser()
                var ifemailVerified = loginUser?["emailVerified"] as! Bool
                if ifemailVerified == true
                {*/
                    
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize();
                self.dismissViewControllerAnimated(true, completion: nil);
                
                 DonateSpotUserSession.isLocationManagerIntited = false
                let svc : SpotLocationService = SpotLocationService()
                svc.IsUserHaveActivePaidBid()
               let loginUser = PFUser.currentUser()
                var searcgRadium = loginUser?["SearchRadium"] as? String
                if searcgRadium == nil{
                    loginUser!["SearchRadium"] = "1"
                loginUser!.saveInBackgroundWithBlock({
                
                (success: Bool, error: NSError?) -> Void in
                
                
                })}

                
                let installation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()}
               /* if installation.badge != 0 {
                    installation.badge = 0
                    installation.saveEventually()
                }*/
               
               // }
               /* else
                {
                    self.displayMyAlertMessage("Please verify the link we send to you" );
                }}*/
        
            
            
            else
            {
                
                
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
                NSUserDefaults.standardUserDefaults().synchronize();
                
                self.displayMyAlertMessage("Email or password is not valid");
                
                self.dismissViewControllerAnimated(true, completion: nil);

                
            }
        })
    
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

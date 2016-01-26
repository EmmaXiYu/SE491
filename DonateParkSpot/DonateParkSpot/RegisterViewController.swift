//
//  RegisterViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 10/23/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    
    @IBOutlet weak var repeatPasswordTextFiled: UITextField!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        
        
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        
        let userEmail = userEmailTextField.text;
        
        let userPassword = userPasswordTextField.text;
        
        let userRepeatPassword = repeatPasswordTextFiled.text;
        
        //Check empty content
        if userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty
        {
            
            
            // display a message and return
            
            displayMyAlertMessage("All fileds are required.");
            return;
            
        }
        
        
        //Check if password matches
        if(userPassword != userRepeatPassword)
        {
            displayMyAlertMessage("Password does not match.");
            //dispaly message and return
            return;
        }
        
        
        //Store data
        /*NSUserDefaults.standardUserDefaults().setObject(userEmail,forKey:"userEmail");
        NSUserDefaults.standardUserDefaults().setObject(userPassword,forKey:"userPassword");
        NSUserDefaults.standardUserDefaults().synchronize();*/
        
        SignUp()
        
        
        //confirm regisration
        var myAlert=UIAlertController(title: "Alert", message:"Registration is successful. Please check email to verify your account.",
            preferredStyle: UIAlertControllerStyle.Alert);
        let okayAction=UIAlertAction(title: "Okay", style:UIAlertActionStyle.Default)
            {
                action in
                self.dismissViewControllerAnimated(true, completion: nil);
                
        }
        myAlert.addAction(okayAction);
        self.presentViewController(myAlert,animated:true, completion: nil);

    }
    
 
    func displayMyAlertMessage(usermessage:String)
    {
        let myAlert=UIAlertController(title: "Alert", message:usermessage,
            preferredStyle: UIAlertControllerStyle.Alert);
        let okayAction=UIAlertAction(title: "Okay", style:UIAlertActionStyle.Default, handler:nil)
        myAlert.addAction(okayAction);
        self.presentViewController(myAlert, animated: true, completion: nil);
        
        
    }
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        
        func SignUp()
        {
            
            //Store in parse
            var user = PFUser()
            user.username =  userEmailTextField.text;
            user.email =  userEmailTextField.text!.lowercaseString;
            user.password = userPasswordTextField.text;
            
            
            user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                
                
                if error == nil {
                    // Hooray! Let them use the app now.
                    
                    
                } else {
                    
                    
                    // Examine the error object and inform the user.
                }

        }
    
}

}


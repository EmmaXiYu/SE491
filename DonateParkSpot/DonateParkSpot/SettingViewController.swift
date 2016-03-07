//
//  SettingViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 11/16/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse

class SettingViewController: UIViewController {
  
  
    @IBOutlet weak var Stepper: UIStepper!

    var radium : Int = 0
    
    

 
    @IBOutlet weak var RadiumLable: UILabel!

   
       @IBOutlet weak var Menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.title = "Settings"
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        Stepper.wraps = true
        Stepper.autorepeat = true
        Stepper.maximumValue = 100
     
        
        var radiumUser = PFUser.currentUser()!["SearchRadium"] as? String
        
        
        if radiumUser == nil
        {
            Stepper.value = 1
            RadiumLable.text = "1"
        }
        else{
            Stepper.value = Double(radiumUser!)!
            RadiumLable.text = radiumUser}
        
       
    }
  
    
 
    
    @IBAction func StepperChangeValue(sender: UIStepper) {
        
        RadiumLable.text = Int(sender.value).description
    }
    
    
    
    
    @IBAction func UpdateSettings(sender: AnyObject) {
        let user = PFUser.currentUser()
        
        user!["SearchRadium"] = RadiumLable.text
      
        user!.saveInBackgroundWithBlock({
            
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                self.displayMyAlertMessage("Updated sucessfully.")
                self.viewDidLoad()
                
            }else {
                print(error)
                self.displayMyAlertMessage("data uploaded fail" );
            }
            
        })
    }
    
    func displayMyAlertMessage(usermessage:String)
        
    {
        
        let myAlert=UIAlertController(title: "Alert", message:usermessage,
            
            preferredStyle: UIAlertControllerStyle.Alert);
        
        let okayAction=UIAlertAction(title: "Okay", style:UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okayAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);}


}

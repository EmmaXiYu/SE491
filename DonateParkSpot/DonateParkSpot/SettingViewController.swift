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
        
        Stepper.wraps = true
        Stepper.autorepeat = true
        Stepper.maximumValue = 100
      
               var radium = PFUser.currentUser()!["SearchRadium"] as? String
          Stepper.value = Double(radium!)!
        RadiumLable.text = radium
    }

    @IBAction func StepperValueChanged(sender: UIStepper) {
        
   
        
         RadiumLable.text = Int(sender.value).description
    }
    
    
    @IBAction func updateSetting(sender: AnyObject) {
        
        
        
        let user = PFUser.currentUser()
        
        user!["SearchRadium"] = RadiumLable.text
        user!.saveInBackgroundWithBlock({
            
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                self.displayMyAlertMessage("Updated sucessfully.")
                self.viewDidLoad()
                
            }else {
                
                self.displayMyAlertMessage("Data update failed");
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

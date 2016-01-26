//
//  AccountViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 11/16/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import Parse

class AccountViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var ifChoose:Bool! = false
   
   
    @IBAction func resetPassword(sender: AnyObject) {
        
         let user = PFUser.currentUser()
        var emailAddress : String = (user?.email)!
        do {try  PFUser.requestPasswordResetForEmail(emailAddress)}
        catch
        {
        //Throw exception}
        }
        
    }
    @IBOutlet weak var Menu: UIBarButtonItem!
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
                Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
         accountName.text = PFUser.currentUser()!["username"] as? String
        cellPhoneNumber.text = PFUser.currentUser()! ["PhoneNumber"] as? String
        if let userPicture = PFUser.currentUser()?["Image"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.ImageField.image = UIImage(data:imageData!)
                }
            }
        }
}
    
    
    @IBOutlet weak var ImageField: UIImageView!
    
    
    @IBOutlet weak var accountName: UITextField!
    
    @IBOutlet weak var ratingScore: UITextField!
    
    @IBOutlet weak var cellPhoneNumber: UITextField!
    
    
    @IBAction func chooseAPicture(sender: AnyObject) {
        
  
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        ifChoose = true;
        

    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        ImageField.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
    }
    

    func displayMyAlertMessage(usermessage:String)
        
    {
        
        let myAlert=UIAlertController(title: "Alert", message:usermessage,
            
            preferredStyle: UIAlertControllerStyle.Alert);
        
        let okayAction=UIAlertAction(title: "Okay", style:UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okayAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);}
    
    
    @IBAction func upLoadProfile(sender: AnyObject) {
        
        if ifChoose == false {
            
            //image is not included alert user
            
            displayMyAlertMessage("Image not chosen");
            
            
            
        }
        
        else
        {
            let user = PFUser.currentUser()
                 let imageData = UIImagePNGRepresentation(self.ImageField.image!)
               let parseImageFile = PFFile(name: "Profile.png", data: imageData!)
            
            user!["Image"] = parseImageFile
            user!.saveInBackgroundWithBlock({
                
                (success: Bool, error: NSError?) -> Void in
                
                if error == nil {
                    self.displayMyAlertMessage("data uploaded");
                    
                }else {
                    
                    self.displayMyAlertMessage("data uploaded fail");
                    }
                
            })
            
            
            

            

        }
    }
    
    
    @IBAction func EditCellPhoneNumber(sender: AnyObject) {
        
        let user = PFUser.currentUser()
        
        user!["PhoneNumber"] = cellPhoneNumber.text
        user!.saveInBackgroundWithBlock({
            
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
             self.displayMyAlertMessage("Updated sucessfully.")
                self.viewDidLoad()
                
            }else {
                
                self.displayMyAlertMessage("data uploaded fail");
            }
            
        })

      
       
        
    }
    
    
    }

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
    
    var ifChoose:Bool = false
    var rate : Double = 0
    var count:Int = 0
    @IBOutlet weak var ratingScore: UILabel!
   
    @IBAction func save(sender: UIBarButtonItem) {
        if ifChoose {
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
        self.title = "My Account"
        self.getRating()
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
    
    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var ImageField: UIImageView!
    
    @IBOutlet weak var cellPhoneNumber: UITextField!
    
    @IBAction func chooseAPicture(sender: AnyObject) {
        
  
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        ifChoose = true;
        

    }
    
    
    func getRating(){
        let users = (PFUser.currentUser()?.username)!
        getBuyerRating(users)
        getSellerRating(users)
        self.ratingScore.text = String(self.formulateScore(rate,count: count))
    }
    
    func getBuyerRating(buyers:String)-> Void{
        var query:PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        query.whereKey("UserId", equalTo: buyers)
        query.selectKeys(["StatusId"])
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects!{
                    let statusId = object["StatusId"] as! Int
                    if(statusId == 3){
                        self.rate = self.rate+1.0
                        self.count = self.count+1
                    }
                    else if(statusId == 6){
                        self.rate = self.rate-1.0
                        self.count = self.count+1
                    }
                }
            }
        }
    }
    
    func getSellerRating(sellers:String) -> Void{
        var query:PFQuery = PFQuery()
        query = PFQuery(className: "Bid")
        let innerQuery = PFQuery(className: "User")
        innerQuery.whereKey("username",equalTo:sellers)
        query.whereKey("user",matchesQuery:innerQuery)
        query.selectKeys(["StatusId","user"])
        query.findObjectsInBackgroundWithBlock{
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                for object in objects!{
                    let statusId = object["StatusId"] as! Int
                    if(statusId == 3){
                        self.rate = self.rate+1.0
                        self.count = self.count+1
                    }
                    else if(statusId == 7){
                        self.rate = self.rate-1.0
                        self.count = self.count+1
                    }
                }
            }
        }
        
        
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
    
    
    
    
    func formulateScore(rating:Double,count:Int) ->Double{
        if count == 0{
            return 0;
        }
        else{
            return (rating/Double(count)+1.0)*2.5;
        }
    }
    

}

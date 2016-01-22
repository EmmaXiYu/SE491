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
    
   
    @IBOutlet weak var Menu: UIBarButtonItem!
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
                Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

}
    
    
    @IBOutlet weak var ImageField: UIImageView!
    
    
    
    
    @IBAction func chooseAPicture(sender: AnyObject) {
        
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        

    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        ImageField.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
    }
    

    
}
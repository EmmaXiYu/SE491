//
//  ViewController.swift
//  DonateParkSpot
//
//  Created by Apple on 10/22/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

     
    override func viewDidAppear(animated: Bool) {
       
       
        
       let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        
        
        if(!isUserLoggedIn)
        {
            self.performSegueWithIdentifier("loginView", sender: self)
        }else{
            self.performSegueWithIdentifier("revealView", sender: self)
           
        }
        
        
    }
}


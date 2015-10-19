//
//  ViewController.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 10/6/15.
//  Copyright © 2015 SE491. All rights reserved.
//

import UIKit

class Register: UIViewController{

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var passowrd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logged" {
            
        }
    }
    
    @IBAction func signIn(sender: AnyObject) {
        if username.text != "" && passowrd.text != ""{
            performSegueWithIdentifier("logged", sender: nil)
        }
    }
}


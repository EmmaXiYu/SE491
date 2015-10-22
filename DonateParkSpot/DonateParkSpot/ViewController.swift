//
//  ViewController.swift
//  DonatingParkingSpotE
//
//  Created by Apple on 10/19/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var passowrd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //TEST PUSH BY PRAVANGSU
    }


    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("LoginView", sender: self)
    }
    
    @IBAction func signIn(sender: AnyObject) {
        if username.text != "" && passowrd.text != ""{
            performSegueWithIdentifier("logged", sender: nil)
        }
    }
}


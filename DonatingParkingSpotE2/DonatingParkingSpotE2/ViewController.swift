//
//  ViewController.swift
//  DonatingParkingSpotE2
//
//  Created by Apple on 10/19/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("LoginView", sender: self)
    }

}


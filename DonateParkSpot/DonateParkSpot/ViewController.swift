//
//  ViewController.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 10/6/15.
//  Copyright © 2015 SE491. All rights reserved.
//

import UIKit

class Register: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        if true {
            performSegueWithIdentifier("logged", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logged" {
            
        }
    }

}


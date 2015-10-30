//
//  MySpotDetail.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 10/29/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class MySpotDetail: UIViewController {
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblMinPrice: UILabel!
    var DetailSpot : Spot = Spot()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblAddress.text =  String(format:"%f", DetailSpot.location.longitude) + "  " +  String(format:"%f", DetailSpot.location.longitude)
        self.lblMinPrice.text = String(DetailSpot.minDonation)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

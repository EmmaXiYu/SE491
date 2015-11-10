//
//  BuyDetailController.swift
//  DonateParkSpot
//
//  Created by Rafael Guerra on 10/29/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import MapKit
import Parse

class BuyDetailController : UIViewController {
    var spot : Spot?
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var timeToLeave: UILabel!
    @IBOutlet weak var minDonation: UILabel!
    @IBOutlet weak var donation: UIStepper!
    
    override func viewDidLoad() {
        if spot != nil {
            map.centerCoordinate = CLLocationCoordinate2D(latitude: spot!.location.latitude, longitude: spot!.location.longitude)
            type.text = spot!.type
            rate.text = spot!.rate.description
            timeToLeave.text = "15:30"
            minDonation.text = "$ " + spot!.minDonation.description + ".00"
            donation.minimumValue = Double(spot!.minDonation)
            donation.stepValue = 1
        }
    }
    
    @IBAction func upDown(sender: UIStepper) {
        minDonation.text = "$ " + sender.value.description
    }
    
    @IBAction func buy() {
        let user = PFUser.currentUser()
        
        let bid = PFObject(className: "Bid")
        bid["user"] = user
        bid["value"] = donation.value
        bid["spot"] = PFObject(withoutDataWithClassName: "Spot", objectId: spot?.spotId)
        
        bid.saveInBackground()

    }
}

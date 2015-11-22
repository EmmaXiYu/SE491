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

class BuyDetailController :  UIViewController, MKMapViewDelegate {
    var spot : Spot?
    var ownerName:String = ""
    var ownerId:String = ""
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var timeToLeave: UILabel!
    @IBOutlet weak var minDonation: UILabel!
    @IBOutlet weak var donation: UIStepper!
       let locationManager=CLLocationManager()
    
    override func viewDidLoad() {
        if spot != nil {
            
            type.text = String(spot!.type)
            rate.text = spot!.rate!.description
            timeToLeave.text = "15:30"
            minDonation.text = "$ " + spot!.minDonation!.description + ".00"
            donation.minimumValue = Double(spot!.minDonation!)
            donation.stepValue = 1
             self.map.delegate = self
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
         
             let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (spot?.location.latitude)!, longitude: (spot?.location.longitude)!)
          let region=MKCoordinateRegion(center: pinLocation, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
          self.map.setRegion(region, animated: true)
            let annotation = CustomerAnnotation(coordinate: pinLocation,spotObject: spot!, title :ownerName,subtitle: ownerId)
            //annotation.subtitle = "Rating bar here"
            self.map.addAnnotation(annotation)
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
        bid["UserId"] = PFUser.currentUser()?.username  //TODO
        bid["StatusId"] = 0  // put 0 by defualt
        
        bid.saveInBackground()

    }
    
    

}

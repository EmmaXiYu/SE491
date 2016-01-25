//
//  MySpotDetail.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 10/29/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
import CoreLocation

class MySpotDetail: UIViewController {
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblMinPrice: UILabel!
    var DetailSpot : Spot = Spot()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblAddress.text =  String(format:"%f", DetailSpot.location.latitude) + "  " +  String(format:"%f", DetailSpot.location.longitude)
        self.lblMinPrice.text = String(DetailSpot.minDonation)
              
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: DetailSpot.location.latitude, longitude: DetailSpot.location.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            let placeArray = placemarks! as? [CLPlacemark]
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                 self.lblAddress.text = String(locationName)
            }
        
        })
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

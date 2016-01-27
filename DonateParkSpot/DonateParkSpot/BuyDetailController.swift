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
    //var ownerName:String = ""
   //var ownerId:String = ""
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var timeToLeave: UILabel!
    @IBOutlet weak var minDonation: UILabel!
    @IBOutlet weak var donation: UIStepper!
    let locationManager=CLLocationManager()
    
    override func viewDidLoad() {
        if spot != nil {
            self.title = spot!.ownerName! + "'s Spot"
            
            if spot!.type! == 1 {
                type.text = "Paid Spot"
                rate.text = "U$ " + spot!.rate!.description + "0"
                timeToLeave.text = spot!.timeToLeave?.description
                minDonation.text = "U$ " + spot!.minDonation!.description + ".00"
            }else{
                type.text = "Free Spot"
                rate.text = "Free"
                timeToLeave.text = "Zero Minutes"
                minDonation.text = "U$ " + spot!.minDonation!.description + ".00"
            }
            donation.minimumValue = Double(spot!.minDonation!)
            donation.maximumValue = 1.79e307
            donation.stepValue = 1
            self.map.delegate = self
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
         
             let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (spot?.location.latitude)!, longitude: (spot?.location.longitude)!)
          let region=MKCoordinateRegion(center: pinLocation, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
          self.map.setRegion(region, animated: true)
            let annotation = CustomerAnnotation(coordinate: pinLocation,spotObject: spot!, title :(spot?.ownerName)!,subtitle: (spot?.ownerID)!)
            //annotation.subtitle = "Rating bar here"
            self.map.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation
        ) -> MKAnnotationView!{
            
            
            if annotation is CustomerAnnotation {
                let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
                var ownerID:String = annotation.subtitle!!
                var name = annotation.title!
                
                let pic = UIImageView (image: UIImage(named: "test.png"))
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.draggable = true
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.animatesDrop = true
                pinAnnotationView.pinColor = MKPinAnnotationColor.Purple
                
                
                var query = PFUser.query()
                
                do{ var user = try query!.getObjectWithId(ownerID) as! PFUser
                    if let userPicture = user["Image"] as? PFFile {
                        userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                pic.image = UIImage(data:imageData!)
                            
                            }
                        }
                    }
                    
                    
                    
                    
                }
                catch{
                   //Throw an exception
                }
               
                pinAnnotationView.leftCalloutAccessoryView = pic
                pic.frame = CGRectMake(0, 0, 40, 40);

                
                
                return pinAnnotationView
                
            }
            
            return nil
    }
    

        
    

    
    @IBAction func upDown(sender: UIStepper) {
        minDonation.text = "U$ " + sender.value.description + "0"
    }
    
    @IBAction func buy() {
        let user = PFUser.currentUser()
        
        let bid = PFObject(className: "Bid")
        bid["user"] = user
        bid["value"] = donation.value
        bid["spot"] = PFObject(withoutDataWithClassName: "Spot", objectId: spot?.spotId)
        bid["StatusId"] = 0  // put 0 by defualt
        bid["UserId"] = user?.email
        bid.saveInBackground()
        
        updateSpot((self.spot?.spotId)!, status : 99)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func updateSpot(spotid : String, status :Int)-> Void
    {
        let prefQuery = PFQuery(className: "Spot")
        prefQuery.getObjectInBackgroundWithId(spotid){
            (prefObj: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                
            } else if let prefObj = prefObj {
                prefObj["StatusId"] = status
                prefObj.saveInBackground()
                
            }
        }
    }

}

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
            self.title = spot!.owner!.email! + "'s Spot"
            
            if spot!.type == 1 {
                type.text = "Paid Spot"
                rate.text = "U$ " + spot!.rate.description + "0"
                timeToLeave.text = spot!.timeToLeave?.description
                minDonation.text = "U$ " + spot!.minDonation.description + ".00"
            }else{
                type.text = "Free Spot"
                rate.text = "Free"
                timeToLeave.text = "Zero Minutes"
                minDonation.text = "U$ " + spot!.minDonation.description + ".00"
            }
            donation.minimumValue = Double(spot!.minDonation)
            donation.maximumValue = 1.79e307
            donation.stepValue = 1
            self.map.delegate = self
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
         
             let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (spot?.location.latitude)!, longitude: (spot?.location.longitude)!)
          let region=MKCoordinateRegion(center: pinLocation, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
          self.map.setRegion(region, animated: true)
            let annotation = CustomerAnnotation(coordinate: pinLocation,spotObject: spot!, title :(spot!.owner!.email!),subtitle: (spot!.owner?.objectId)!)
            //annotation.subtitle = "Rating bar here"
            self.map.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation
        ) -> MKAnnotationView!{
            
            
            if let a = annotation as? CustomerAnnotation {
                let pinAnnotationView = MKPinAnnotationView(annotation: a, reuseIdentifier: "myPin")
                //let ownerID:String = a.subtitle!
                let spot = a.spot
                let ownerScore = a.spot.owner?.getRatingAsSeller()
                let name = a.title!
                let ownerID:String = (a.spot.owner?.objectId)!
                a.subtitle = String(ownerScore!)
                let pic = UIImageView (image: UIImage(named: "test.png"))
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.draggable = false
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.animatesDrop = true
                pinAnnotationView.pinColor = MKPinAnnotationColor.Purple
                
                
                let query = PFUser.query()
                
                do{ let user = try query!.getObjectWithId(ownerID) as! PFUser
                    if let userPicture = user["Image"] as? PFFile {
                        userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                pic.image = UIImage(data:imageData!)
                            }
                        }
                    }
                    
                    
                    
                    
                }
                catch{
                    //Throw exception here
                }
               
                pic.frame = CGRectMake(0, 0, 40, 40);
                pinAnnotationView.leftCalloutAccessoryView = pic
                pinAnnotationView.frame = CGRectMake(0,0,500,500)
                return pinAnnotationView
                
            }
            
            return nil
    }
    
    

    
    @IBAction func upDown(sender: UIStepper) {
        minDonation.text = "U$ " + sender.value.description + "0"
    }
    
    @IBAction func buy() {
        if(IsValidBuyer() == true)
        {
        let user = PFUser.currentUser()
        
        let query = PFQuery.init(className: "Bid")
        query.whereKey("user", equalTo: user!)
        query.whereKey("spot", equalTo: spot!.toPFObject())
        query.whereKey("StatusId", notEqualTo: 4) // 4 is cancel by bid owner
        do{
            let results = try query.findObjects()
            if results.count > 0 {
                let alert = UIAlertView.init(title: "Bid already made", message: "You cannot bid twice on a Spot. You can cancel your current Bid and bid again for this Spot", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                return
            }
        }catch{
            
        }
        
        let bid = Bid()
        bid.bidder = user
        bid.value = donation.value
        bid.spot = spot
        bid.statusId = 0  // put 0 by defualt
        bid.cancelByBidder = false
        bid.toPFObjet().saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if(success){
                print(success)
            }else{
                print(error)
            }
        }
        
        updateSpot((self.spot?.spotId)!, status : 1)
            
        
             /* let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("SpotOwner", equalTo: spot!.toPFObject()["owner"] as! PFUser)
            
            let data = [
                "alert" : "Your spot got a bid." ,
                "badge" : "Increment",
                "sound" : "iphonenoti_cRjTITC7.mp3",
               
           
                
            ]
            // Send push notification to query
           // let push = PFPush()
            //push.setQuery(pushQuery) // Set our Installation query
            //push.setData(data)
            //push.sendPushInBackground()*/
            
           // let installation = PFInstallation.currentInstallation()
            //installation["SpotBidder"] = bid.bidder
            //installation.saveInBackground()

            
            self.dismissViewControllerAnimated(true, completion: nil)
            }

    } 
    
    func IsValidBuyer()->Bool

    {
        var IsValid = true
        var msg = ""
        if(spot?.owner?.email == PFUser.currentUser()?.email)
        {
            IsValid = false
            msg = "You can not Bid your Own Spot"  + "\r\n"
            
        }
        if(msg.characters.count > 0)
        {
            let alertController = UIAlertController(title: "Validation Error", message: msg, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
        }
        return IsValid
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

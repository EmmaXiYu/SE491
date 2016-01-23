//
//  SpotLocationService.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 1/23/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation
import Parse

class SpotLocationService {
  
    
    
    
    func getTimeForHourEarlierFromNow(HoursFromNow : Int) -> NSDate
    {
        let components: NSDateComponents = NSDateComponents()
        components.setValue(-HoursFromNow, forComponent: NSCalendarUnit.Hour);
        let date: NSDate = NSDate()
        let EarlierFromNow = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        
        return EarlierFromNow!
    }
    
}
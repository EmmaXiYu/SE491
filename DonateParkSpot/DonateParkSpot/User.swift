//
//  User.swift
//  DonateParkSpot
//
//  Created by Apple on 10/24/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class User: NSObject {
    
    
    var username = String()
    
    func getUserName() -> String {
       
        return username
    }


    
    func setUserName(personName: String){
        
        
        username = personName
    }
}

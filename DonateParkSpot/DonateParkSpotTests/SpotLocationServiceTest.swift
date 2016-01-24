//
//  SpotLocationServiceTest.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 1/23/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import XCTest
@testable import DonateParkSpot
class SpotLocationServiceTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testgetTimeForHourEarlierFromNow() {
        let objclass : SpotLocationService =  SpotLocationService()
        let partdate =  objclass.getTimeForHourEarlierFromNow(12)
        print("Current Date from main  at " + String(NSDate()) + "  pastDate Retuen from Function: " + String(partdate))
       
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}

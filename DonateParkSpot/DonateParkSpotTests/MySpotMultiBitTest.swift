//
//  MySpotMultiBitTest.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 1/17/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import XCTest
import Parse
@testable import DonateParkSpot
class MySpotMultiBitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMinutesElaps()
    {
        let objclass : MySpotMultiBidTableViewController =  MySpotMultiBidTableViewController()
        let calendar = NSCalendar.currentCalendar()
        let newDate = calendar.dateByAddingUnit(
            .Minute,  // adding hours
            value: -2, // adding two hours
            toDate: NSDate(),
            options:   []
        )
        let minutesElames =  objclass.MinuteElaps(newDate!);
        XCTAssertEqual (minutesElames, 2, "MinuteElaps should 2")
    }
    
    func testMinutesElapsZero()
    {
        let objclass : MySpotMultiBidTableViewController =  MySpotMultiBidTableViewController()
        let calendar = NSCalendar.currentCalendar()
        let newDate = calendar.dateByAddingUnit(
            .Minute,  // adding hours
            value: 0, // adding two hours
            toDate: NSDate(),
            options:   []
        )
        let minutesElames =  objclass.MinuteElaps(newDate!);
        XCTAssertEqual(minutesElames, 0, "MinuteElaps should 0")
    }
    
    func testMinutesElapsMinus()
    {
        let objclass : MySpotMultiBidTableViewController =  MySpotMultiBidTableViewController()
        let calendar = NSCalendar.currentCalendar()
        let newDate = calendar.dateByAddingUnit(
            .Minute,  // adding hours
            value: -5, // adding two hours
            toDate: NSDate(),
            options:   []
        )
        let minutesElames =  objclass.MinuteElaps(newDate!);
        XCTAssertEqual(minutesElames, 5, "MinuteElaps should -5")
    }
    func testGetEmptyBid()
    {
        let objclass : MySpotMultiBidTableViewController =  MySpotMultiBidTableViewController()
        let bid =  objclass.GetEmptyBid();
        XCTAssertNotNil(bid,  "bid should be nil")
    }
   
    /*
    func testUpdateSpot()
    {
        let objclass : MySpotMultiBidTableViewController =  MySpotMultiBidTableViewController()
        let bid = Bid()
        bid.bidId = "13mNXjah02"
        let pfObject : PFObject =  objclass.updateBid(bid, status: 2, sender: nil);
        let value = pfObject["StatusId"] as! Int

        
        XCTAssertEqual(value, 2, "bid status should 2")
    }
    */
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

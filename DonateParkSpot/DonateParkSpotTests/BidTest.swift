//
//  BidTest.swift
//  DonateParkSpot
//
//  Created by Pravangsu Biswas on 1/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import XCTest
@testable import DonateParkSpot

class BidTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetBidList() {
      
        let bi: Bid = Bid()

        var spotbid : MySpotBiddingTableViewController =  MySpotBiddingTableViewController()
        var bids : [Bid] = spotbid.GetBid(2)
        XCTAssertEqual(2, bids.count, "the array should have  two bids")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

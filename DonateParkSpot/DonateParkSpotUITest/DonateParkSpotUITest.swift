//
//  DonateParkSpotUITest.swift
//  DonateParkSpotUITest
//
//  Created by Rafael Guerra on 1/15/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import XCTest

class DonateParkSpotUITest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRoutineOne(){
        let app = XCUIApplication()
        if app.navigationBars["DonateParkSpot.MapView"].exists {
            testLogout(true)
        }
        testLogin("rafael@kloog.com.br", password: "galo13")
        testLookForSpot("Chicago")
        testBidOnSpot(true)
        testCheckMyBids(true)
        testCheckMySpots(true)
        testCheckMyAccount(true)
        testCheckMySettings(true)
        testAddASpot(true)
        testLogout(true)
    }
    
    func testRoutineTwo(){
        let app = XCUIApplication()
        if app.navigationBars["DonateParkSpot.MapView"].exists {
            testLogout(true)
        }
        let email = randomStringWithLength(4) + "@" + randomStringWithLength(4) + ".com"
        let password = randomStringWithLength(6)
        testRegister(email, password: password)
        testLogin(email, password: password)
    }
    
    func randomStringWithLength (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString.description
    }
    
    func testLogin(email: String, password: String) {
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        let app = XCUIApplication()
        XCTAssertEqual(app.textFields["Email:"].exists, true)

        let emailTextField = app.textFields["Email:"]
        emailTextField.tap()
        emailTextField.typeText(email)
        
        let passwordSecureTextField = app.secureTextFields["Password:"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        app.buttons["Login"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        
    }
    

    
    func testLookForSpot(place: String) {
        
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        let typeAAddressToSearchAParkingSpotSearchField = app.searchFields["type a address to search a parking spot"]
        typeAAddressToSearchAParkingSpotSearchField.tap()
        typeAAddressToSearchAParkingSpotSearchField.typeText(place)
        app.typeText("\r")
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        
    }
    

    
    func testBidOnSpot(test: Bool){
        
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        app.otherElements["xiyu332012@gmail.com, lYqRItyF7B"].tap()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Button).element.tap()
        
        let incrementButton = app.steppers.buttons["Increment"]
        incrementButton.tap()
        incrementButton.tap()
        app.buttons["BUY"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.BuyDetail"].exists, true)
        app.navigationBars["DonateParkSpot.BuyDetail"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        
    }
    
    func testCheckMyBids(test: Bool){
        
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        app.navigationBars["DonateParkSpot.MapView"].buttons["Menu"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["My Bids"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MyBidTableView"].exists, true)
        
        app.navigationBars["DonateParkSpot.MyBidTableView"].buttons["Menu"].tap()
        tablesQuery.staticTexts["Map"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        
    }
    
    func testCheckMySpots(test: Bool){
        
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        app.navigationBars["DonateParkSpot.MapView"].buttons["Menu"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["My Spots"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MySpotBiddingTableView"].exists, true)
        app.navigationBars["DonateParkSpot.MySpotBiddingTableView"].buttons["Menu"].tap()
        tablesQuery.staticTexts["Map"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)

    }
    
    func testCheckMyAccount(test: Bool){
        
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        app.navigationBars["DonateParkSpot.MapView"].buttons["Menu"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Account"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.AccountView"].exists, true)
        app.navigationBars["DonateParkSpot.AccountView"].buttons["Menu"].tap()
        tablesQuery.staticTexts["Map"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
    }
    
    func testCheckMySettings(test: Bool){
        
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        app.navigationBars["DonateParkSpot.MapView"].buttons["Menu"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Settings"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.SettingView"].exists, true)
        app.navigationBars["DonateParkSpot.SettingView"].buttons["Menu"].tap()
        tablesQuery.staticTexts["Map"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
    }
    
    func testAddASpot(test: Bool){
        
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        app.buttons["+"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["Add Spot Detail"].exists, true)
        let tablesQuery = app.tables
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(3).childrenMatchingType(.TextField).element.tap()
        app.datePickers.pickerWheels.elementAtIndex(0).swipeUp()
        tablesQuery.textFields["Minimum Donation"].tap()
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(4).childrenMatchingType(.TextField).element.typeText("5")
        app.navigationBars["Add Spot Detail"].buttons["Done"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        
    }
 

    
    func testLogout(test: Bool){
        
        let app = XCUIApplication()
        XCTAssertEqual(app.navigationBars["DonateParkSpot.MapView"].exists, true)
        app.navigationBars["DonateParkSpot.MapView"].buttons["Menu"].tap()
        app.tables.staticTexts["Logout"].tap()
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.buttons["Login"].exists, true)
    }
    
    func testRegister(email: String, password: String){
        
        let app = XCUIApplication()
        let window = app.childrenMatchingType(.Window).elementBoundByIndex(0)
        window.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.doubleTap()
        XCTAssertEqual(app.buttons["Login"].exists, true)
        let registerButton = app.buttons["Register"]
        registerButton.tap()
        
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.buttons["I have an account. Let me login."].exists, true)
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText(email)
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText(password)
        app.secureTextFields["Repeat Password"].tap()
        app.secureTextFields["Repeat Password"].typeText(password)
        registerButton.tap()
        app.alerts["Alert"].collectionViews.buttons["Okay"].tap()
        
        NSThread.sleepForTimeInterval(5)
        XCTAssertEqual(app.buttons["Login"].exists, true)
    }
}

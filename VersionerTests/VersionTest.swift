//
//  VersionTest.swift
//  PrinceOfVersionsTests
//
//  Created by Barbara Vujicic on 20/12/2017.
//  Copyright © 2017 Infinum Ltd. All rights reserved.
//

import XCTest

class VersionTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEqualMethod() {
        let versionOne = try! Version(string: "10")
        let versionTwo = try! Version(string: "10.0-0")
        let versionThree = try! Version(string: "10.0.0-1")
        let versionFour = try! Version(string: "10-0")
        
        XCTAssertTrue(versionOne == versionTwo)
        XCTAssertFalse(versionOne == versionThree)
        XCTAssertTrue(versionOne == versionFour)
    }
    
    func testNotEqualMethod() {
        let versionOne = try! Version(string: "10")
        let versionTwo = try! Version(string: "10.0.0")
        let versionThree = try! Version(string: "10.1")
        let versionFour = try! Version(string: "10-0")
        
        XCTAssertFalse(versionOne != versionTwo)
        XCTAssertTrue(versionOne != versionThree)
        XCTAssertFalse(versionOne != versionFour)
    }
    
    func testGreaterThanMethod() {
        let versionOne = try! Version(string: "10.2-3")
        let versionTwo = try! Version(string: "10.2")
        let versionThree = try! Version(string: "10.2.3")
        let versionFour = try! Version(string: "10.1.1-99")
        
        XCTAssertTrue(versionOne > versionTwo)
        XCTAssertFalse(versionOne > versionThree)
        XCTAssertTrue(versionOne > versionFour)
    }
    
    func testLessThanMethod() {
        let versionOne = try! Version(string: "10.2-3")
        let versionTwo = try! Version(string: "10.2")
        let versionThree = try! Version(string: "10.2.3")
        let versionFour = try! Version(string: "10.1.1-99")
        
        XCTAssertFalse(versionOne < versionTwo)
        XCTAssertTrue(versionOne < versionThree)
        XCTAssertFalse(versionOne < versionFour)
    }
}

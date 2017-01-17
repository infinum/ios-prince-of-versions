//
//  UpdateInfoTest.swift
//  Prince of versions
//
//  Created by Jasmin Abou Aldan on 21/09/2016.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import XCTest

class UpdateInfoTest: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCheckingValidContent() {
        let bundle = Bundle(for: type(of: self))

        var info: UpdateInfo?
        if let jsonPath = bundle.path(forResource: "valid_update_full", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                info = try UpdateInfo(data: data, bundle: Bundle(for: type(of: self)))
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }

        guard let _info = info else {
            XCTFail("Update info should not be nil")
            return
        }

        XCTAssertNotNil(_info.minimumRequiredVersion.major, "Value for installed version should not be nil")
    }
}

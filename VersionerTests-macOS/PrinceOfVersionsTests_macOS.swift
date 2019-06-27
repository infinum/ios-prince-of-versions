//
//  PrinceOfVersionsTests_macOS.swift
//  PrinceOfVersionsTests-macOS
//
//  Created by Nikola Majcen on 23/07/2018.
//  Copyright © 2018 Infinum Ltd. All rights reserved.
//

import XCTest
@testable import PrinceOfVersions_macOS

class PrinceOfVersionsTests_macOS: XCTestCase {
    
    func testCheckingValidContent() {
        let bundle = Bundle(for: type(of: self))

        var info: UpdateInfo?
        if let jsonPath = bundle.path(forResource: "update_info", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
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

        XCTAssertNotNil(_info.minimumRequiredVersion, "Value for minimum required version should not be nil")
    }
}

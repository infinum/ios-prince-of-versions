//
//  UpdateInfoTest.swift
//  Prince of versions
//
//  Created by Jasmin Abou Aldan on 21/09/2016.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import XCTest
@testable import PrinceOfVersions

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
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                info = try decoder.decode(UpdateInfo.self, from: data)
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }

        guard let updateInfo = info else {
            XCTFail("Update info should not be nil")
            return
        }

        let updateResult = UpdateResult(updateInfo: updateInfo)

        XCTAssertNotNil(updateResult.updateInfo.requiredVersion, "Value for required version should not be nil")
    }

    func testCheckingValidV2Content() {

        let bundle = Bundle(for: type(of: self))

        var info: UpdateInfo?

        if let jsonPath = bundle.path(forResource: "valid_update_only_v2_metadata_empty", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                info = try decoder.decode(UpdateInfo.self, from: data)
                
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }

        guard let updateInfo = info else {
            XCTFail("Update info should not be nil")
            return
        }

        let updateResult = UpdateResult(updateInfo: updateInfo)

        XCTAssertNotNil(updateResult.updateInfo.requiredVersion, "Value for required version should not be nil")
    }

    func testCheckingValidV2OnlyIosContent() {

        let bundle = Bundle(for: type(of: self))

        var info: UpdateInfo?

        if let jsonPath = bundle.path(forResource: "valid_update_only_v2_ios", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                info = try decoder.decode(UpdateInfo.self, from: data)

            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }

        guard let updateInfo = info else {
            XCTFail("Update info should not be nil")
            return
        }

        let updateResult = UpdateResult(updateInfo: updateInfo)

        #if os(iOS)
        XCTAssertNotNil(updateResult.updateInfo.requiredVersion, "Value for required version should not be nil")
        #endif
    }

    func testCheckingValidV2OnlyMacosContent() {

        let bundle = Bundle(for: type(of: self))

        var info: UpdateInfo?

        if let jsonPath = bundle.path(forResource: "valid_update_only_v2_macos", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                info = try decoder.decode(UpdateInfo.self, from: data)

            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }

        guard let updateInfo = info else {
            XCTFail("Update info should not be nil")
            return
        }

        let updateResult = UpdateResult(updateInfo: updateInfo)

        #if os(macOS)
        XCTAssertNotNil(updateResult.updateInfo.requiredVersion, "Value for required version should not be nil")
        #endif
    }

    // MARK: - CaseInsensitiveDecodable

    func testNotificationTypeDecodesCaseInsensitively() throws {
        for raw in ["ALWAYS", "Always", "always", "aLwAyS"] {
            XCTAssertEqual(try decodeNotificationType(from: raw), .always, "'\(raw)' should decode to .always")
        }
        for raw in ["ONCE", "Once", "once", "oNcE"] {
            XCTAssertEqual(try decodeNotificationType(from: raw), .once, "'\(raw)' should decode to .once")
        }
    }

    func testNotificationTypeDecodingThrowsForUnknownValue() {
        XCTAssertThrowsError(try decodeNotificationType(from: "sometimes"))
    }

    func testCheckingValidCaseInsensitiveNotificationContent() {
        let bundle = Bundle(for: type(of: self))

        var info: UpdateInfo?
        if let jsonPath = bundle.path(forResource: "valid_update_case_insensitive_notification", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                info = try decoder.decode(UpdateInfo.self, from: data)
            } catch let error {
                XCTFail("Mixed-case notification frequency should decode without error: \(error.localizedDescription)")
            }
        }

        guard let updateInfo = info else {
            XCTFail("Update info should not be nil")
            return
        }

        let updateResult = UpdateResult(updateInfo: updateInfo)
        let notificationType = updateResult.updateInfo.notificationType
        XCTAssertTrue([.always, .once].contains(notificationType), "Notification type should resolve to a valid value")
    }

    private func decodeNotificationType(from raw: String) throws -> NotificationType {
        let data = Data("\"\(raw)\"".utf8)
        return try JSONDecoder().decode(NotificationType.self, from: data)
    }
}

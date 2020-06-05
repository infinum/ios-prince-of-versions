//
//  RequirementsTest.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 05/06/2020.
//

import XCTest
@testable import PrinceOfVersions

class RequirementsTest: XCTestCase {

    var updateInfoWithoutRequirements: UpdateInfo?
    var updateInfoWithIncreasingRequirements: UpdateInfo?
    var updateInfoWithDecreasingRequirements: UpdateInfo?
    var updateInfoWithShuffledRequirements: UpdateInfo?

    let regionKey = "region"
    let bluetoothKey = "bluetooth"

    override func setUp() {
        super.setUp()
        fetchData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCheckingValidWithoutRequirementsWithoutChecks() {
        XCTAssertNotNil(updateInfoWithoutRequirements?.configuration)
    }

    func testCheckingValidWithoutRequirementsWithChecks() {
        updateInfoWithoutRequirements?.userRequirements.updateValue(regionCheck, forKey: regionKey)
        XCTAssertNotNil(updateInfoWithoutRequirements?.configuration)
    }

    func testCheckingValidWithIncreasingRequirementsWithoutChecks() {
        XCTAssertNotNil(updateInfoWithIncreasingRequirements?.configuration)
    }

    func testCheckingValidWithIncreasingRequirementsWithOneCheck() {
        updateInfoWithIncreasingRequirements?.userRequirements.updateValue(regionCheck, forKey: regionKey)
        XCTAssertNotNil(updateInfoWithIncreasingRequirements?.configuration)
    }

    func testCheckingValidWithIncreasingRequirementsWithTwoChecks() {

        updateInfoWithIncreasingRequirements?.userRequirements.updateValue(regionCheck, forKey: regionKey)

        updateInfoWithIncreasingRequirements?.userRequirements.updateValue(bluetoothCheck, forKey: bluetoothKey)

        let configsAreEqual = configsEqual(
            config1: updateInfoWithIncreasingRequirements?.configurations?.first,
            config2: updateInfoWithIncreasingRequirements?.configuration
        )

        XCTAssertTrue(configsAreEqual)
    }

    func testCheckingValidWithDecreasingRequirementsWithoutChecks() {
        XCTAssertNotNil(updateInfoWithDecreasingRequirements?.configuration)
    }

    func testCheckingValidWithDecreasingRequirementsWithOneCheck() {

       updateInfoWithDecreasingRequirements?.userRequirements.updateValue(regionCheck, forKey: regionKey)

        let configsAreEqual = configsEqual(config1: updateInfoWithDecreasingRequirements?.configurations?.first, config2: updateInfoWithDecreasingRequirements?.configuration)

        XCTAssertFalse(configsAreEqual)
    }

    func testCheckingValidWithDecreasingRequirementsWithTwoChecks() {

        updateInfoWithDecreasingRequirements?.userRequirements.updateValue(regionCheck, forKey: regionKey)

        updateInfoWithDecreasingRequirements?.userRequirements.updateValue(bluetoothCheck, forKey: bluetoothKey)

        let configsAreEqual = configsEqual(
            config1: updateInfoWithDecreasingRequirements?.configuration,
            config2: updateInfoWithDecreasingRequirements?.configurations?.first
        )

        XCTAssertFalse(configsAreEqual)
    }

    func testCheckingValidWithShuffledRequirementsWithoutChecks() {
        XCTAssertNotNil(updateInfoWithShuffledRequirements?.configuration)
    }

    func testCheckingValidWithShuffledRequirementsWithOneCheck() {

       updateInfoWithShuffledRequirements?.userRequirements.updateValue(regionCheck, forKey: regionKey)

        let configsAreEqual = configsEqual(config1: updateInfoWithShuffledRequirements?.configurations?.first, config2: updateInfoWithShuffledRequirements?.configuration)

        XCTAssertTrue(configsAreEqual)
    }

    func testCheckingValidWithShuffledRequirementsWithTwoChecks() {

        updateInfoWithShuffledRequirements?.userRequirements.updateValue(regionCheck, forKey: regionKey)

        updateInfoWithShuffledRequirements?.userRequirements.updateValue(bluetoothCheck, forKey: bluetoothKey)

        let configsAreEqual = configsEqual(
            config1: updateInfoWithShuffledRequirements?.configuration,
            config2: updateInfoWithShuffledRequirements?.configurations?.first
        )

        XCTAssertTrue(configsAreEqual)
    }
}

// MARK: - Requirement Check Closures -

extension RequirementsTest {

    var bluetoothCheck: (Any) -> Bool {
        return { value in
            guard let value = value as? String else { return false }
            return value.starts(with: "5")
        }
    }

    var regionCheck: (Any) -> Bool {
        return { region in
            guard let region = region as? String else { return false }
            return region.starts(with: "hr")
        }
    }
}

// MARK: - Helpers -

private extension RequirementsTest {

    func fetchData() {

        let bundle = Bundle(for: type(of: self))

        if let jsonPath = bundle.path(forResource: "valid_update_no_requirements", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                updateInfoWithoutRequirements = try decoder.decode(UpdateInfo.self, from: data)
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }

        if let jsonPath = bundle.path(forResource: "valid_update_with_increasing_requirements", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                updateInfoWithIncreasingRequirements = try decoder.decode(UpdateInfo.self, from: data)
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }

        if let jsonPath = bundle.path(forResource: "valid_update_with_decreasing_requirements", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                updateInfoWithDecreasingRequirements = try decoder.decode(UpdateInfo.self, from: data)
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }

        if let jsonPath = bundle.path(forResource: "valid_update_with_shuffled_requirements", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                updateInfoWithShuffledRequirements = try decoder.decode(UpdateInfo.self, from: data)
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func configsEqual(config1: ConfigurationData?, config2: ConfigurationData?) -> Bool {
        return
            config1?.lastVersionAvailable == config2?.lastVersionAvailable &&
            config1?.notifyLastVersionFrequency == config2?.notifyLastVersionFrequency &&
            config1?.requiredVersion == config2?.requiredVersion &&
            config1?.requirements?.allRequirements?.count == config2?.requirements?.allRequirements?.count
    }
}

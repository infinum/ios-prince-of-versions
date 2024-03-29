//
//  PrinceOfVersionsTest.swift
//  Prince of versions
//
//  Created by Jasmin Abou Aldan on 21/09/2016.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import XCTest
@testable import PrinceOfVersions

class PrinceOfVersionsTest: XCTestCase {

    static let testURL = URL(string: "https://pastebin.com/raw/0MfYmWGu")!

    func testLoadConfigurationBaseOnMain() {
        runAsyncTest { finished in
            PrinceOfVersions.checkForUpdates(
                from: PrinceOfVersionsTest.testURL,
                completion: {  _ in
                   XCTAssertTrue(Thread.isMainThread)
                   finished()
            })
        }
    }

    func testLoadConfigurationBaseOnBackground() {
        runAsyncTest { finished in
            PrinceOfVersions.checkForUpdates(
                from: PrinceOfVersionsTest.testURL,
                callbackQueue: .global(qos: .background),
                completion: { _ in
                    XCTAssertFalse(Thread.isMainThread)
                    finished()
            })
        }
    }

    func testAutomaticUpdateFromStore() {

        let bundle = Bundle(for: type(of: self))
        let jsonPath = bundle.path(forResource: "app_store_version_example", ofType: "json")!

        let installedVersion = try! Version(string: "1.0.0-1")
        let lastVersionAvailable = try! Version(string: "0.1.0")
        let minimumSdkForLatestVersion = try! Version(string: "12.0")

        runAsyncTest { finished in
            PrinceOfVersions.internalyGetDataFromAppStore(
                URL(fileURLWithPath: jsonPath),
                trackPhaseRelease: false,
                bundle: bundle,
                testMode: true,
                cachePolicy: .reloadIgnoringLocalCacheData,
                completion: { result in
                    switch result {
                    case .success(let updateResult):
                        XCTAssert(updateResult.updateInfo.installedVersion == installedVersion)

                        guard let latestVersion = updateResult.updateInfo.lastVersionAvailable else {
                            XCTFail("Last version available should not be nil")
                            return
                        }

                        XCTAssert(latestVersion == lastVersionAvailable)
                        if let minSdkForLatestVersion = updateResult.updateInfo.configurationData?.minimumOsVersion {
                            XCTAssert(minSdkForLatestVersion == minimumSdkForLatestVersion)
                        } else {
                            XCTFail("min sdk should not be nil")
                        }
                        XCTAssert(!updateResult.phaseReleaseInProgress)
                        finished()
                    case .failure:
                        XCTFail("Invalid data")
                        finished()
                    }
                }
            )
        }
    }

    func testAutomaticUpdateFromStorePhased() {
        let bundle = Bundle(for: type(of: self))
        let jsonPath = bundle.path(forResource: "app_store_version_example", ofType: "json")!
        runAsyncTest { finished in
            PrinceOfVersions.internalyGetDataFromAppStore(
                URL(fileURLWithPath: jsonPath),
                trackPhaseRelease: true,
                bundle: bundle,
                testMode: true,
                cachePolicy: .reloadIgnoringLocalCacheData,
                completion: { result in
                    switch result {
                    case .success(let info):
                        XCTAssert(!info.phaseReleaseInProgress)
                        finished()
                    case .failure:
                        XCTFail("Invalid data")
                        finished()
                    }
                }
            )
        }
    }
}

private extension PrinceOfVersionsTest {

    func runAsyncTest(with description: String = #function, test: ( @escaping () -> Void ) -> Void) {
        let expectation = XCTestExpectation(description: description)
        test {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}

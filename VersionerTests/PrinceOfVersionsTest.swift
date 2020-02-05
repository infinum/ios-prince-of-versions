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

    static let testURL = URL(string: "https://pastebin.com/raw/ZAfWNZCi")!

    func testLoadConfigurationBaseOnMain() {
        runAsyncTest { finished in
            PrinceOfVersions().loadConfiguration(
                from: PrinceOfVersionsTest.testURL,
                completion: { _ in
                    XCTAssertTrue(Thread.isMainThread)
                    finished()
            })
        }
    }

    func testLoadConfigurationBaseOnBackground() {
        runAsyncTest { finished in
            PrinceOfVersions().loadConfiguration(
                from: PrinceOfVersionsTest.testURL,
                callbackQueue: .background,
                completion: { _ in
                    XCTAssertFalse(Thread.isMainThread)
                    finished()
            })
        }
    }

    func testCheckForUpdatesBaseOnMain() {
        runAsyncTest { finished in
            PrinceOfVersions().checkForUpdates(
                from: PrinceOfVersionsTest.testURL,
                newVersion: { _,_,_  in
                    XCTAssertTrue(Thread.isMainThread)
                    finished()
                }, noNewVersion: { _,_  in
                    XCTAssertTrue(Thread.isMainThread)
                    finished()
                }, error: { error in
                    XCTAssertTrue(Thread.isMainThread)
                    finished()
                })
        }
    }

    func testCheckForUpdatesBaseOnBackground() {
        runAsyncTest { finished in
            PrinceOfVersions().checkForUpdates(
                from: PrinceOfVersionsTest.testURL,
                callbackQueue: .background,
                newVersion: { _,_,_ in
                    XCTAssertFalse(Thread.isMainThread)
                    finished()
                }, noNewVersion: { _,_ in
                    XCTAssertFalse(Thread.isMainThread)
                    finished()
                }, error: { _ in
                    XCTAssertFalse(Thread.isMainThread)
                    finished()
                })
        }
    }
}

private extension PrinceOfVersionsTest {

    func runAsyncTest(with description: String = #function, test: ( @escaping () -> Void ) -> Void) {
        let expectation = XCTestExpectation(description: description)
        test() {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}

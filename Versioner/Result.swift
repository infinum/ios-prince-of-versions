//
//  Result.swift
//  PrinceOfVersions
//
//  Created by Vedran Burojevic on 19/05/2017.
//  Copyright © 2017 Infinum Ltd. All rights reserved.
//

import Foundation

public class Result: NSObject {
    @objc public let updateInfo: UpdateInfo?
    @objc public let error: Error?
    
    @objc public init(updateInfo: UpdateInfo?, error: Error?) {
        self.updateInfo = updateInfo
        self.error = error
    }
}

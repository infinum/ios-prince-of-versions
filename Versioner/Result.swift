//
//  Result.swift
//  PrinceOfVersions
//
//  Created by Vedran Burojevic on 19/05/2017.
//  Copyright © 2017 Infinum Ltd. All rights reserved.
//

import Foundation

public class Result: NSObject {
    let updateInfo: UpdateInfo?
    let error: Error?
    
    public init(updateInfo: UpdateInfo?, error: Error?) {
        self.updateInfo = updateInfo
        self.error = error
    }
}

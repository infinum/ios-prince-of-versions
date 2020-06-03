//
//  UpdateResultObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

@objcMembers
public class UpdateResultObject: NSObject {

    // MARK: - Private properties

    private var updateResult: UpdateResult

    // MARK: - Init

    init(from updateResult: UpdateResult) {
        self.updateResult = updateResult
    }
}

// MARK: - Public wrappers -

extension UpdateResultObject: BaseUpdateResult {

    /// The biggest version it is possible to update to, or current version of the app if it isn't possible to update
    public var updateVersion: Version {
        return updateResult.updateVersion
    }

    /// Resolution of the update check
    public var updateState: UpdateStatus {
        return updateResult.updateState
    }

    /// Update configuration values used to check
    @objc
    public var updateInfo: UpdateInfoObject {
        return UpdateInfoObject(from: updateResult.updateInfoData)
    }
}

extension UpdateResultObject {

    /// Merged metadata from JSON
    public var metadata: [String : Any]? {
        return updateResult.metadata
    }
}

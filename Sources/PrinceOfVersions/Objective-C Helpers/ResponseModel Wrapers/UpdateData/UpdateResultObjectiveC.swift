//
//  UpdateResultObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

public protocol UpdateResultObjectValues {
    var updateVersion: Version { get }
    var updateState: UpdateResultObject.UpdateStatusType { get }
    var versionInfo: UpdateInfoObject { get }
    var metadata: [String: Any]? { get }
}

@objcMembers
public class UpdateResultObject: NSObject {

    // MARK: - Private properties
    private var updateResult: UpdateResult

    // MARK: - Public update status type
    @objc public enum UpdateStatusType: Int {
        case noUpdateAvailable
        case requiredUpdateNeeded
        case newUpdateAvailable
    }

    // MARK: - Init
    init(from updateResult: UpdateResult) {
        self.updateResult = updateResult
    }
}

// MARK: - Public wrappers -

extension UpdateResultObject: UpdateResultObjectValues {

    /// The biggest version it is possible to update to, or current version of the app if it isn't possible to update
    public var updateVersion: Version {
        return updateResult.updateVersion
    }

    /// Resolution of the update check
    public var updateState: UpdateStatusType {
        return updateResult.updateState.updateStatusType
    }

    /// Update configuration values used to check
    public var versionInfo: UpdateInfoObject {
        return UpdateInfoResponseObject(from: updateResult.versionInfo).versionInfo
    }

    /// Merged metadata from JSON
    public var metadata: [String : Any]? {
        return updateResult.metadata
    }
}

// MARK: - Private helpers -

internal extension UpdateStatus {

    var updateStatusType: UpdateResultObject.UpdateStatusType {
        switch self {
        case .noUpdateAvailable: return .noUpdateAvailable
        case .requiredUpdateNeeded: return .requiredUpdateNeeded
        case .newUpdateAvailable: return .newUpdateAvailable
        }
    }
}

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

    public var updateVersion: Version {
        return updateResult.updateVersion
    }

    public var updateState: UpdateStatusType {
        return updateResult.updateState.updateStatusType
    }

    public var versionInfo: UpdateInfoObject {
        return UpdateInfoObject(from: updateResult.versionInfo)
    }

    public var metadata: [String : Any]? {
        return updateResult.metadata
    }
}

// MARK: - Private helpers -

private extension UpdateStatus {

    var updateStatusType: UpdateResultObject.UpdateStatusType {
        switch self {
        case .noUpdateAvailable: return .noUpdateAvailable
        case .requiredUpdateNeeded: return .requiredUpdateNeeded
        case .newUpdateAvailable: return .newUpdateAvailable
        }
    }
}

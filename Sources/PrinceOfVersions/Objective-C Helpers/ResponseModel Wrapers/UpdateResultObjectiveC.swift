//
//  UpdateResultObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

@objc
public protocol UpdateInfoObjectValues {
    var requiredVersion: Version? { get }
    var lastVersionAvailable: Version? { get }
    var installedVersion: Version { get }
    var requirements: [String: Any]? { get }
}

public protocol UpdateResultObjectValues {
    var updateVersion: Version { get }
    var updateState: UpdateResultObject.UpdateStatusType { get }
    var versionInfo: UpdateInfoObject { get }
    var metadata: [String: Any]? { get }
}

@objcMembers
public class UpdateInfoObject: NSObject {

    /// Returns data containing information about possible update.
    public var updateData: UpdateInfoObjectValues?

    /// Returns current SDK version.
    public var sdkVersion: Version?

    /**
     Returns notification type.

     Possible values are:
     - Once: Show notification only once
     - Always: Show notification every time app run

     Default value is `.once`
     */
    public var notificationType: UpdateNotificationType = .once

    /**
     Returns bool value if phased release period is in progress

     Used only with automated check from AppStore if new version is available.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value send by `itunes.apple.com` API.
     */
    public var phaseReleaseInProgress: Bool = false
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

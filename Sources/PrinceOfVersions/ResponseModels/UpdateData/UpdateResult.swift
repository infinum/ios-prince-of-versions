//
//  UpdateResult.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 17/04/2020.
//

import Foundation

public enum UpdateStatus {
    case noUpdateAvailable
    case requiredUpdateNeeded
    case newUpdateAvailable
}

public protocol UpdateResultValues {
    var updateVersion: Version { get }
    var updateState: UpdateStatus { get }
    var versionInfo: UpdateInfo { get }
    var metadata: [String: Any]? { get }
}

public struct UpdateResult {

    // MARK: - Private properties
    private var updateInfoResponse: UpdateInfoResponse

    // MARK: - Init
    init(updateInfoResponse: UpdateInfoResponse) {
        self.updateInfoResponse = updateInfoResponse
    }

}

// MARK: - UpdateResultValues -

extension UpdateResult: UpdateResultValues {

    /// The biggest version it is possible to update to, or current version of the app if it isn't possible to update
    public var updateVersion: Version {

        if let requiredVersion = updateInfoResponse.requiredVersion, let lastVersionAvailable = updateInfoResponse.lastVersionAvailable {
            return Version.max(requiredVersion, lastVersionAvailable)
        }

        if let requiredVersion = updateInfoResponse.requiredVersion, updateInfoResponse.lastVersionAvailable == nil {
            return Version.max(requiredVersion, updateInfoResponse.installedVersion)
        }

        if updateInfoResponse.requiredVersion == nil, let lastVersionAvailable = updateInfoResponse.lastVersionAvailable {
            return Version.max(lastVersionAvailable, updateInfoResponse.installedVersion)
        }

        return updateInfoResponse.installedVersion
    }

    /// Resolution of the update check
    public var updateState: UpdateStatus {

        if let requiredVersion = updateInfoResponse.requiredVersion, requiredVersion > updateInfoResponse.installedVersion {
            return .requiredUpdateNeeded
        }

        guard let latestVersion = updateInfoResponse.lastVersionAvailable else {
            return .noUpdateAvailable
        }

        let shouldNotify = !latestVersion.wasNotified || updateInfoResponse.notificationType == .always

        if (latestVersion > updateInfoResponse.installedVersion) && shouldNotify {
            updateInfoResponse.lastVersionAvailable?.markNotified()
            return .newUpdateAvailable
        }

        return .noUpdateAvailable
    }

    /// Update configuration values used to check
    public var versionInfo: UpdateInfo {
        return updateInfoResponse.versionInfo
    }

    /// Merged metadata from JSON
    public var metadata: [String : Any]? {
        return updateInfoResponse.metadata
    }
}

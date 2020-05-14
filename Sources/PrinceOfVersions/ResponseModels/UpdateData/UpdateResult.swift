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

protocol UpdateResultValues {
    var updateVersion: Version { get }
    var updateState: UpdateStatus { get }
    var versionInfo: UpdateInfo { get }
    var metadata: [String: Any]? { get }
}

public struct UpdateResult {

    // MARK: - Private properties
    private var updateInfo: UpdateInfo

    // MARK: - Init
    init(updateInfo: UpdateInfo) {
        self.updateInfo = updateInfo
    }

}

// MARK: - UpdateResultValues -

extension UpdateResult: UpdateResultValues {

    public var updateVersion: Version {

        if let requiredVersion = updateInfo.requiredVersion, let lastVersionAvailable = updateInfo.lastVersionAvailable {
            return Version.max(requiredVersion, lastVersionAvailable)
        }

        if let requiredVersion = updateInfo.requiredVersion, updateInfo.lastVersionAvailable == nil {
            return Version.max(requiredVersion, updateInfo.installedVersion)
        }

        if updateInfo.requiredVersion == nil, let lastVersionAvailable = updateInfo.lastVersionAvailable {
            return Version.max(lastVersionAvailable, updateInfo.installedVersion)
        }

        return updateInfo.installedVersion
    }

    public var updateState: UpdateStatus {

        if let requiredVersion = updateInfo.requiredVersion, requiredVersion > updateInfo.installedVersion {
            return .requiredUpdateNeeded
        }

        guard let latestVersion = updateInfo.lastVersionAvailable else {
            return .noUpdateAvailable
        }

        let shouldNotify = !latestVersion.wasNotified || updateInfo.notificationType == .always

        if (latestVersion > updateInfo.installedVersion) && shouldNotify {
            updateInfo.lastVersionAvailable?.markNotified()
            return .newUpdateAvailable
        }

        return .noUpdateAvailable
    }

    public var versionInfo: UpdateInfo {
        return updateInfo
    }

    /**
     Returns global metadata merged with metadata for configuration.
     */
    public var metadata: [String : Any]? {
        return updateInfo.metadata
    }
}
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

    private var updateInfo: UpdateInfo

    init(updateInfo: UpdateInfo) {
        self.updateInfo = updateInfo
    }

    public func validate() -> PrinceOfVersionsError? {
        return nil
    }
}

extension UpdateResult: UpdateResultValues {

    public var updateVersion: Version {

        if let requiredVersion = updateInfo.requiredVersion, let lastVersionAvailable = updateInfo.lastVersionAvailable {
            return Version.getGreaterVersion(requiredVersion, lastVersionAvailable)
        }

        if let requiredVersion = updateInfo.requiredVersion, updateInfo.lastVersionAvailable == nil {
            return Version.getGreaterVersion(requiredVersion, updateInfo.installedVersion)
        }

        if updateInfo.requiredVersion == nil, let lastVersionAvailable = updateInfo.lastVersionAvailable {
            return Version.getGreaterVersion(lastVersionAvailable, updateInfo.installedVersion)
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

    public var metadata: [String : Any]? {
        return updateInfo.metadata
    }
}

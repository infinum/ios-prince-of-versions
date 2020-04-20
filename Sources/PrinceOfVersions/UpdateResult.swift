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
        return updateInfo.lastVersionAvailable ?? updateInfo.installedVersion
    }

    public var updateState: UpdateStatus {

        if let minimumSdk = updateInfo.requiredVersion, minimumSdk > updateInfo.installedVersion {
            return .noUpdateAvailable
        }

        guard let latestVersion = updateInfo.lastVersionAvailable else { return .noUpdateAvailable }

        if (latestVersion > updateInfo.installedVersion) &&
            (!latestVersion.wasNotified || updateInfo.notificationType == .always) {
            updateInfo.lastVersionAvailable?.markNotified()
            return .newUpdateAvailable
        }

        return .noUpdateAvailable
    }

    public var versionInfo: UpdateInfo {
        return updateInfo
    }

    public var metadata: [String : Any]? {
        return nil
    }
}

//
//  UpdateResult.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 17/04/2020.
//

import Foundation

public struct UpdateResult {

    // MARK: - Private properties

    internal var updateInfoData: UpdateInfo

    // MARK: - Init
    
    init(updateInfo: UpdateInfo) {
        self.updateInfoData = updateInfo
    }
}

// MARK: - Public properties -

extension UpdateResult: BaseUpdateResult {

    /// The biggest version it is possible to update to, or current version of the app if it isn't possible to update
    public var updateVersion: Version {

        if let requiredVersion = updateInfoData.requiredVersion, let lastVersionAvailable = updateInfoData.lastVersionAvailable {
            return Version.max(requiredVersion, lastVersionAvailable)
        }

        if let requiredVersion = updateInfoData.requiredVersion, updateInfoData.lastVersionAvailable == nil {
            return Version.max(requiredVersion, updateInfoData.installedVersion)
        }

        if updateInfoData.requiredVersion == nil, let lastVersionAvailable = updateInfoData.lastVersionAvailable {
            return Version.max(lastVersionAvailable, updateInfoData.installedVersion)
        }

        return updateInfoData.installedVersion
    }

    /// Resolution of the update check
    public var updateState: UpdateStatus {

        if let requiredVersion = updateInfoData.requiredVersion, requiredVersion > updateInfoData.installedVersion {
            return .requiredUpdateNeeded
        }

        guard let latestVersion = updateInfoData.lastVersionAvailable else {
            return .noUpdateAvailable
        }

        let shouldNotify = !latestVersion.wasNotified || updateInfoData.notificationType == .always

        if (latestVersion > updateInfoData.installedVersion) && shouldNotify {
            updateInfoData.lastVersionAvailable?.markNotified()
            return .newUpdateAvailable
        }

        return .noUpdateAvailable
    }

    /// Update configuration values used to check
    public var updateInfo: UpdateInfo {
        return updateInfoData
    }
}

extension UpdateResult {

    /// Merged metadata from JSON
    public var metadata: [String : Any]? {
        return updateInfoData.metadata
    }
}

//
//  AppStoreUpdateResult.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 02/06/2020.
//

import Foundation

public struct AppStoreUpdateResult {

    // MARK: - Private properties

    internal var updateInfoData: AppStoreUpdateInfo

    // MARK: - Init

    init(updateInfo: AppStoreUpdateInfo) {
        self.updateInfoData = updateInfo
    }
}

// MARK: - Public properties -

extension AppStoreUpdateResult: BaseUpdateResult {

    /// The biggest version it is possible to update to, or current version of the app if it isn't possible to update
    public var updateVersion: Version {

        guard let latestVersion = updateInfoData.lastVersionAvailable else {
            return updateInfoData.installedVersion
        }

        return Version.max(latestVersion, updateInfoData.installedVersion)
    }

    /// Resolution of the update check
    public var updateState: UpdateStatus {

        guard let latestVersion = updateInfoData.lastVersionAvailable else {
            return .noUpdateAvailable
        }

        return latestVersion > updateInfoData.installedVersion ? .newUpdateAvailable : .noUpdateAvailable
    }

    /// Update configuration values used to check
    public var updateInfo: AppStoreUpdateInfo {
        return updateInfoData
    }
}

extension AppStoreUpdateResult {

    public var phaseReleaseInProgress: Bool {
        return updateInfoData.phaseReleaseInProgress
    }
}

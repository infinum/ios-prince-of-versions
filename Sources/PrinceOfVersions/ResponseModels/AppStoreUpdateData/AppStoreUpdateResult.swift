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

    /**
     Resolution of the update check.

     Only possible return values are `.newUpdateAvailable` and `.noUpdateAvailable` since  there is no way to determine if the update version is mandatory with AppStore check.
     */
    public var updateState: UpdateStatus {

        guard let latestVersion = updateInfoData.lastVersionAvailable else {
            return .noUpdateAvailable
        }

        let shouldNotify = !latestVersion.wasNotified || updateInfoData.notificationFrequency == .always

        if (latestVersion > updateInfoData.installedVersion) && shouldNotify {
            updateInfoData.lastVersionAvailable?.markNotified()
            return .newUpdateAvailable
        }

        return .noUpdateAvailable
    }

    /// Update configuration values used to check
    public var updateInfo: AppStoreUpdateInfo {
        return updateInfoData
    }
}

extension AppStoreUpdateResult {

    /**
     Returns bool value if phased release period is in progress.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value send by `itunes.apple.com` API.
     */
    public var phaseReleaseInProgress: Bool {
        return updateInfoData.phaseReleaseInProgress
    }
}

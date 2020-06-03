//
//  AppStoreUpdateResultObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

@objcMembers
public class AppStoreUpdateResultObject: NSObject {

    // MARK: - Private properties

    private var updateResult: AppStoreUpdateResult

    // MARK: - Init

    init(from updateResult: AppStoreUpdateResult) {
        self.updateResult = updateResult
    }
}

// MARK: - Public wrappers -

// Should be updated with new properties from UpdateInfo

extension AppStoreUpdateResultObject: BaseUpdateResult {

    /// The biggest version it is possible to update to, or current version of the app if it isn't possible to update
    public var updateVersion: Version {
        return updateResult.updateVersion
    }

    /// Resolution of the update check
    public var updateState: UpdateStatus {
        return updateResult.updateState
    }

    /// Update configuration values used to check
    @objc
    public var updateInfo: AppStoreUpdateInfoObject {
        return AppStoreUpdateInfoObject(from: updateResult.updateInfoData)
    }
}

extension AppStoreUpdateResultObject {

    /**
     Returns bool value if phased release period is in progress.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value send by `itunes.apple.com` API.
     */
    public var phaseReleaseInProgress: Bool {
        return updateResult.phaseReleaseInProgress
    }
}

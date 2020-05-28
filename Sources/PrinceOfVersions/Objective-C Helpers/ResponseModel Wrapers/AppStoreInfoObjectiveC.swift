//
//  UpdateInfoObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

@objcMembers
public class AppStoreInfoObject: NSObject {

    // MARK: - Private properties
    private var appStoreInfo: AppStoreInfo

    // MARK: - Init
    internal init(from appStoreInfo: AppStoreInfo) {
        self.appStoreInfo = appStoreInfo
    }
}

// MARK: - Public wrappers -

// Should be updated with new properties from UpdateInfo

extension AppStoreInfoObject: UpdateInfoValues {

    /// Returns minimum required version of the app.
    public var requiredVersion: Version? {
        return appStoreInfo.requiredVersion
    }

    /// Returns latest available version of the app.
    public var lastVersionAvailable: Version? {
        return appStoreInfo.lastVersionAvailable
    }

    /// Returns installed version of the app.
    public var installedVersion: Version {
        return appStoreInfo.installedVersion
    }

    /// Returns requirements for configuration.
    public var requirements: [String : Any]? {
        return appStoreInfo.requirements
    }
}

extension AppStoreInfoObject: UpdateResultObjectValues {

    /// The biggest version it is possible to update to, or current version of the app if it isn't possible to update
    public var updateVersion: Version {
        return appStoreInfo.updateVersion
    }

    /// Resolution of the update check
    public var updateState: UpdateResultObject.UpdateStatusType {
        return appStoreInfo.updateState.updateStatusType
    }

    /// Update configuration values used to check
    public var versionInfo: UpdateInfoObject {
        return UpdateInfoResponseObject(from: appStoreInfo.versionInfo).versionInfo
    }

    /// Merged metadata from JSON
    public var metadata: [String : Any]? {
        return appStoreInfo.metadata
    }
}

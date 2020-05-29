//
//  UpdateInfoResponseObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

@objcMembers
public class UpdateInfoResponseObject: NSObject {

    // MARK: - Private properties
    private var updateInfo: UpdateInfo
    private var notificationType: UpdateNotificationType

    // MARK: - Internal properties
    internal var versionInfo: UpdateInfoObject {
        let versionInfo = UpdateInfoObject()
        versionInfo.updateData = self
        versionInfo.sdkVersion = updateInfo.sdkVersion
        versionInfo.notificationType = notificationType
        versionInfo.phaseReleaseInProgress = updateInfo.phaseReleaseInProgress ?? false
        return versionInfo
    }

    // MARK: - Init
    init(from updateInfo: UpdateInfo) {
        self.updateInfo = updateInfo
        self.notificationType = updateInfo.notificationType.updateNotificationType
    }
}

// MARK: - Public wrappers -

// Should be updated with new properties from UpdateInfo

extension UpdateInfoResponseObject: UpdateInfoObjectValues {

    /// Returns minimum required version of the app.
    public var requiredVersion: Version? {
        return updateInfo.updateData.requiredVersion
    }

    /// Returns latest available version of the app.
    public var lastVersionAvailable: Version? {
        return updateInfo.updateData.lastVersionAvailable
    }

    /// Returns installed version of the app.
    public var installedVersion: Version {
        return updateInfo.updateData.installedVersion
    }

    /// Returns requirements for configuration.
    public var requirements: [String : Any]? {
        return updateInfo.updateData.requirements
    }
}

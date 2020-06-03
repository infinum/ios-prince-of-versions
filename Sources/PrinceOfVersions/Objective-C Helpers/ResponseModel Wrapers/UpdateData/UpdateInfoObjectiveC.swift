//
//  UpdateInfoObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 29/05/2020.
//

import Foundation

@objcMembers
public class UpdateInfoObject: NSObject {

    // MARK: - Private properties

    private var updateInfo: UpdateInfo
    private var updateNotificationType: UpdateNotificationType

    // MARK: - Init

    init(from updateInfo: UpdateInfo) {
        self.updateInfo = updateInfo
        self.updateNotificationType = updateInfo.notificationType.updateNotificationType
    }
}

// MARK: - Public wrappers -

// Should be updated with new properties from UpdateInfo

extension UpdateInfoObject: BaseUpdateInfo {

    /// Returns latest available version of the app.
    public var lastVersionAvailable: Version? {
        return updateInfo.lastVersionAvailable
    }

    /// Returns installed version of the app.
    public var installedVersion: Version {
        return updateInfo.installedVersion
    }
}

extension UpdateInfoObject {

    /// Returns minimum required version of the app.
    public var requiredVersion: Version? {
        return updateInfo.requiredVersion
    }

    /// Returns requirements for configuration.
    public var requirements: [String : Any]? {
        return updateInfo.requirements
    }

    /// Returns notification frequency for configuration.
    public var notificationType: UpdateNotificationType {
        return updateNotificationType
    }
}

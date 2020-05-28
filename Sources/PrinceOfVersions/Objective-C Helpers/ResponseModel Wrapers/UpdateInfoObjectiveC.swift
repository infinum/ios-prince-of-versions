//
//  UpdateInfoObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

@objcMembers
public class UpdateInfoObject: NSObject {

    // MARK: - Private properties
    private var versionInfo: UpdateInfo

    // MARK: - Public notification type
    @objc public enum UpdateNotificationType: Int {
        case once
        case always
    }

    // MARK: - Public properties

    /**
     Returns notification type.

     Possible values are:
     - Once: Show notification only once
     - Always: Show notification every time app run

     Default value is `.once`
     */
    @objc public private(set) var notificationType: UpdateNotificationType

    // MARK: - Init
    init(from versionInfo: UpdateInfo) {
        self.versionInfo = versionInfo
        self.notificationType = versionInfo.notificationType.updateNotificationType
    }
}

// MARK: - Public wrappers -

// Should be updated with new properties from UpdateInfo

extension UpdateInfoObject: UpdateInfoValues {

    /**
     Returns minimum required version of the app.
     */
    public var requiredVersion: Version? {
        return versionInfo.updateInfo.requiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var lastVersionAvailable: Version? {
        return versionInfo.updateInfo.lastVersionAvailable
    }

    /**
     Returns installed version of the app.
     */
    public var installedVersion: Version {
        return versionInfo.updateInfo.installedVersion
    }

    /**
     Returns requirements for configuration.
     */
    public var requirements: [String : Any]? {
        return versionInfo.updateInfo.requirements
    }
}

// MARK: - Private helpers -

private extension NotificationType {

    var updateNotificationType: UpdateInfoObject.UpdateNotificationType {
        switch self {
        case .always: return .always
        case .once: return .once
        }
    }
}

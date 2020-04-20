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

    @objc public enum UpdateNotificationType: Int {
        case once
        case always
    }

    // MARK: - Private properties
    private var updateInfo: UpdateInfo

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
    init(from updateInfo: UpdateInfo) {
        self.updateInfo = updateInfo
        self.notificationType = updateInfo.notificationType.updateNotificationType
    }
}

// MARK: - Public wrappers -

// Should be updated with new properties from UpdateInfo

extension UpdateInfoObject: UpdateInfoValues {

    /**
     Returns minimum required version of the app.
     */
    public var requiredVersion: Version? {
        return updateInfo.requiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var lastVersionAvailable: Version? {
        return updateInfo.lastVersionAvailable
    }

    /**
     Returns installed version of the app.
     */
    public var installedVersion: Version {
        return updateInfo.installedVersion
    }

    /**
     Returns requirements for configuration.
     */
    public var requirements: [String : Any]? {
        return updateInfo.requirements
    }
}

// MARK: - Private helpers -

private extension UpdateInfo.NotificationType {

    var updateNotificationType: UpdateInfoObject.UpdateNotificationType {
        switch self {
        case .always:
            return .always
        case .once:
            return .once
        }
    }
}

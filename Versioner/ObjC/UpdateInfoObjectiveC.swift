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
    public var minimumRequiredVersion: Version? {
        return updateInfo.minimumRequiredVersion
    }

    /**
     Returns minimum sdk for minimum required version of the app.
     */
    public var minimumSdkForMinimumRequiredVersion: Version? {
        return updateInfo.minimumSdkForMinimumRequiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var latestVersion: Version {
        return updateInfo.latestVersion
    }

    /**
     Returns sdk for latest available version of the app.
     */
    public var minimumSdkForLatestVersion: Version? {
        return updateInfo.minimumSdkForLatestVersion
    }

    /**
     Returns installed version of the app.
     */
    public var installedVersion: Version {
        return updateInfo.installedVersion
    }

    /**
     Returns sdk version of device.
     */
    public var sdkVersion: Version {
        return updateInfo.sdkVersion
    }

    /**
     Checks and return true if minimum version requirement is satisfied. If minimumRequiredVersion doesn't exist return true.
     */
    public var isMinimumVersionSatisfied: Bool {
        return updateInfo.isMinimumVersionSatisfied
    }

    /**
     Key-value pairs under "meta" key are optional metadata of which any amount can be sent accompanying the required fields.
     */
    public var metadata: [String : Any]? {
        return updateInfo.metadata
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

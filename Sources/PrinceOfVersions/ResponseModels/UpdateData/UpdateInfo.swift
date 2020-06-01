//
//  UpdateInfo.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 29/05/2020.
//

import Foundation

public protocol UpdateInfoValues {
    var requiredVersion: Version? { get }
    var lastVersionAvailable: Version? { get }
    var installedVersion: Version { get }
    var requirements: [String: Any]? { get }
}

public struct UpdateInfo {

    /// Returns struct containing information about possible update.
    public var updateData: UpdateInfoValues

    /// Returns current SDK version.
    public var sdkVersion: Version?

    /**
     Returns notification type.

     Possible values are:
     - Once: Show notification only once
     - Always: Show notification on every app run

     If `notificationType` is not provided by the configuration file, a default value will be set to `.once`.
     */
    public var notificationType: NotificationType = .once

    /**
     Returns bool value if phased release period is in progress

     Used only with automated check from AppStore if new version is available.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value send by `itunes.apple.com` API.
     */
    public var phaseReleaseInProgress: Bool?
}

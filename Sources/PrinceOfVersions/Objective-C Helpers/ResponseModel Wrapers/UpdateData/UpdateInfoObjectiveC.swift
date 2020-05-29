//
//  UpdateInfoObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 29/05/2020.
//

import Foundation

@objc
public protocol UpdateInfoObjectValues {
    var requiredVersion: Version? { get }
    var lastVersionAvailable: Version? { get }
    var installedVersion: Version { get }
    var requirements: [String: Any]? { get }
}

@objcMembers
public class UpdateInfoObject: NSObject {

    /// Returns data containing information about possible update.
    public var updateData: UpdateInfoObjectValues?

    /// Returns current SDK version.
    public var sdkVersion: Version?

    /**
     Returns notification type.

     Possible values are:
     - Once: Show notification only once
     - Always: Show notification every time app run

     Default value is `.once`
     */
    public var notificationType: UpdateNotificationType = .once

    /**
     Returns bool value if phased release period is in progress

     Used only with automated check from AppStore if new version is available.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value send by `itunes.apple.com` API.
     */
    public var phaseReleaseInProgress: Bool = false
}

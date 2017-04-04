//
//  UpdateInfo.swift
//  Pods
//
//  Created by Jasmin Abou Aldan on 06/07/16.
//
//

import Foundation

enum UpdateInfoError: Error {
    case invalidJsonData
    case invalidMinimumVersion
    case invalidCurrentVersion
}

public struct UpdateInfo {

    public enum NotificationType : String {
        case always = "ALWAYS"
        case once = "ONCE"
    }

    /**
     Returns minimum required version of the app.
     */
    public private(set) var minimumRequiredVersion: Version

    /**
     Returns notification type. Possible values are:

     - Once: Show notification only once
     - Always: Show notification every time app run
     
     Default value is @c .once
     */
    public private(set) var notificationType: NotificationType = .once

    /**
     Returns latest available version of the app.
     */
    public private(set) var latestVersion: Version?

    /**
     Returns installed version of the app.
     */
    public private(set) var installedVersion: Version

    /**
     Checks and return true if minimum version requirement is satisfied.
     */
    public var isMinimumVersionSatisfied: Bool {
        return installedVersion >= minimumRequiredVersion
    }

    /**
     Key-value pairs under "meta" key are optional metadata of which any amount can be sent accompanying the required fields.
     */
    public private(set) var metadata: [String: Any]?

    init(data: Data?, bundle: Bundle = Bundle.main) throws {
        guard let _data = data else {
            throw UpdateInfoError.invalidJsonData
        }
        let json = try JSONSerialization.jsonObject(with: _data, options: []) as? NSDictionary

        // JSON data
        guard let value = json as? [String: AnyObject] else {
            throw UpdateInfoError.invalidJsonData
        }
        guard let os = value["ios"] as? [String: AnyObject] else {
            throw UpdateInfoError.invalidJsonData
        }

        // Minimum version
        if let minimumVersion = os["minimum_version"] as? String {
            minimumRequiredVersion = try Version(string: minimumVersion)
        } else {
            throw UpdateInfoError.invalidMinimumVersion
        }

        // Latest version and notification type
        if let optionalUpdate = os["optional_update"] as? [String: AnyObject] {
            let notificationTypeString = (optionalUpdate["notification_type"] as? String) ?? ""

            if let _notificationType = NotificationType(rawValue: notificationTypeString) {
                notificationType = _notificationType
            }

            if let versionString = optionalUpdate["version"] as? String {
                latestVersion = try? Version(string: versionString)
            }
        }

        // Installed version
        guard let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            throw UpdateInfoError.invalidCurrentVersion
        }
        guard let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            throw UpdateInfoError.invalidCurrentVersion   
        }

        installedVersion = try Version(string: currentVersionString + "-" + currentBuildNumberString)

        // Metadata
        metadata = value["meta"] as? [String: Any]
    }

}

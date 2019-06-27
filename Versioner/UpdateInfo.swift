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
    case invalidLatestVersion
    case invalidCurrentVersion
}

public class UpdateInfo: NSObject {
    /**
     Returns minimum required version of the app.
     */
    @objc public private(set) var minimumRequiredVersion: Version?
    
    /**
     Returns notification type. Possible values are:
     
     - Once: Show notification only once
     - Always: Show notification every time app run
     
     Default value is .once
     */
    @objc public private(set) var notificationType: NotificationType = .once
    /**
     Returns latest available version of the app.
     */
    @objc public private(set) var latestVersion: Version
    
    /**
     Returns installed version of the app.
     */
    @objc public private(set) var installedVersion: Version
    /**
     Checks and return true if minimum version requirement is satisfied. If minimumRequiredVersion doesn't exist return true.
     */
    @objc public var isMinimumVersionSatisfied: Bool {
        guard let _minimumRequiredVersion = minimumRequiredVersion else {
            return true
        }
        return installedVersion >= _minimumRequiredVersion
    }
    /**
     Key-value pairs under "meta" key are optional metadata of which any amount can be sent accompanying the required fields.
     */
    @objc public private(set) var metadata: [String: Any]?
    init(data: Data?, bundle: Bundle = Bundle.main) throws {
        guard let _data = data else {
            throw UpdateInfoError.invalidJsonData
        }
        let json = try JSONSerialization.jsonObject(with: _data, options: []) as? NSDictionary
        // JSON data
        guard let value = json as? [String: AnyObject] else {
            throw UpdateInfoError.invalidJsonData
        }

        #if os(iOS)
        guard let os = value["ios"] as? [String: AnyObject] else {
            throw UpdateInfoError.invalidJsonData
        }

        #elseif os(macOS)
        guard let os = value["macos"] as? [String: AnyObject] else {
            throw UpdateInfoError.invalidJsonData
        }
        #else
        throw UpdateInfoError.invalidJsonData
        #endif

        // Minimum version
        if let minimumVersion = os["minimum_version"] as? String {
            minimumRequiredVersion = try? Version(string: minimumVersion)
        }
        // Latest version and notification type
        guard let latestVersionInfo = os["latest_version"] as? [String: AnyObject] else {
            throw UpdateInfoError.invalidLatestVersion
        }
        let notificationTypeString = (latestVersionInfo["notification_type"] as? String) ?? "ONCE"
        notificationType = (notificationTypeString == "ONCE") ? .once : .always
        if let versionString = latestVersionInfo["version"] as? String {
            latestVersion = try Version(string: versionString)
        } else {
            throw UpdateInfoError.invalidLatestVersion
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

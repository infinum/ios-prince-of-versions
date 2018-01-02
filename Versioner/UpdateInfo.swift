//
//  UpdateInfo.swift
//  Pods
//
//  Created by Jasmin Abou Aldan on 06/07/16.
//
//

import Foundation
import UIKit

enum UpdateInfoError: Error {
    case invalidJsonData
    case invalidLatestVersion
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
    public private(set) var minimumRequiredVersion: Version?
    
    /**
     Returns minimum sdk for minimum required version of the app.
     */
    public private(set) var minimumSdkForMinimumRequiredVersion: Version?

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
    public private(set) var latestVersion: Version
    
    /**
     Returns sdk for latest available version of the app.
     */
    public private(set) var minimumSdkForLatestVersion: Version?

    /**
     Returns installed version of the app.
     */
    public private(set) var installedVersion: Version
    
    /**
     Returns sdk version of device.
     */
    public private(set) var sdkVersion: Version

    /**
     Checks and return true if minimum version requirement is satisfied. If minimumRequiredVersion doesn't exist return true.
     */
    public var isMinimumVersionSatisfied: Bool {
        if let _minimumSdkForMinimumRequiredVersion = minimumSdkForMinimumRequiredVersion,
            _minimumSdkForMinimumRequiredVersion > sdkVersion {
            return true
        }
        
        guard let _minimumRequiredVersion = minimumRequiredVersion else {
            return true
        }
        return installedVersion >= _minimumRequiredVersion
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
            minimumRequiredVersion = try? Version(string: minimumVersion)
        }
        
        // Minimum sdk for minimum version
        if let minimumSdkForMinimumVersionString = os["minimum_version_min_sdk"] as? String {
            minimumSdkForMinimumRequiredVersion = try? Version(string: minimumSdkForMinimumVersionString)
        }

        // Latest version and notification type
        guard let latestVersionInfo = os["latest_version"] as? [String: AnyObject] else {
            throw UpdateInfoError.invalidLatestVersion
        }

        let notificationTypeString = (latestVersionInfo["notification_type"] as? String) ?? ""

        if let _notificationType = NotificationType(rawValue: notificationTypeString) {
            notificationType = _notificationType
        }

        if let versionString = latestVersionInfo["version"] as? String {
            latestVersion = try Version(string: versionString)
        } else {
            throw UpdateInfoError.invalidLatestVersion
        }
        
        if let minimumSdkForLatestVersionString = latestVersionInfo["min_sdk"] as? String {
            minimumSdkForLatestVersion = try? Version(string: minimumSdkForLatestVersionString)
        }

        // Installed version
        guard let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            throw UpdateInfoError.invalidCurrentVersion
        }
        guard let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            throw UpdateInfoError.invalidCurrentVersion   
        }

        installedVersion = try Version(string: currentVersionString + "-" + currentBuildNumberString)
        
        sdkVersion = try Version(string: UIDevice.current.systemVersion)

        // Metadata
        metadata = value["meta"] as? [String: Any]
    }

}

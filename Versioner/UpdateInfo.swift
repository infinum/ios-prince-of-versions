//
//  UpdateInfo.swift
//  Pods
//
//  Created by Jasmin Abou Aldan on 06/07/16.
//
//

import Foundation
import UIKit

protocol UpdateInfoValues {
    var minimumRequiredVersion: Version? { get }
    var minimumSdkForMinimumRequiredVersion: Version? { get }
    var latestVersion: Version { get }
    var minimumSdkForLatestVersion: Version? { get }
    var installedVersion: Version { get }
    var sdkVersion: Version { get }
    var isMinimumVersionSatisfied: Bool { get }
    var metadata: [String: Any]? { get }
}

public struct UpdateInfo{

    public enum NotificationType : String {
        case always = "ALWAYS"
        case once = "ONCE"
    }

    // MARK: - Private properties
    private var minRequiredVersion: Version?
    private var minSdkForMinimumRequiredVersion: Version?
    private var latestVers: Version
    private var minSdkForLatestVersion: Version?
    private var installedVers: Version
    private var sdkVers: Version
    private var metadataObject: [String: Any]?

    // MARK: - Public properties

    /**
     Returns notification type.

     Possible values are:
     - Once: Show notification only once
     - Always: Show notification every time app run

     Default value is `.once`
     */
    public private(set) var notificationType: UpdateInfo.NotificationType = .once

    // MARK: - Init -
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
            minRequiredVersion = try? Version(string: minimumVersion)
        }
        
        // Minimum sdk for minimum version
        if let minimumSdkForMinimumVersionString = os["minimum_version_min_sdk"] as? String {
            minSdkForMinimumRequiredVersion = try? Version(string: minimumSdkForMinimumVersionString)
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
            latestVers = try Version(string: versionString)
        } else {
            throw UpdateInfoError.invalidLatestVersion
        }
        
        if let minimumSdkForLatestVersionString = latestVersionInfo["min_sdk"] as? String {
            minSdkForLatestVersion = try? Version(string: minimumSdkForLatestVersionString)
        }

        // Installed version
        guard let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            throw UpdateInfoError.invalidCurrentVersion
        }
        guard let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            throw UpdateInfoError.invalidCurrentVersion   
        }

        installedVers = try Version(string: currentVersionString + "-" + currentBuildNumberString)
        
        sdkVers = try Version(string: UIDevice.current.systemVersion)

        // Metadata
        metadataObject = value["meta"] as? [String: Any]
    }

}

// MARK: - UpdateInfoValues -

extension UpdateInfo: UpdateInfoValues {

    /**
     Returns minimum required version of the app.
     */
    public var minimumRequiredVersion: Version? {
        return minRequiredVersion
    }

    /**
     Returns minimum sdk for minimum required version of the app.
     */
    public var minimumSdkForMinimumRequiredVersion: Version? {
        return minSdkForMinimumRequiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var latestVersion: Version {
        return latestVers
    }

    /**
     Returns sdk for latest available version of the app.
     */
    public var minimumSdkForLatestVersion: Version? {
        return minSdkForLatestVersion
    }

    /**
     Returns installed version of the app.
     */
    public var installedVersion: Version {
        return installedVers
    }

    /**
     Returns sdk version of device.
     */
    public var sdkVersion: Version {
        return sdkVers
    }

    /**
     Checks and return true if minimum version requirement is satisfied. If minimumRequiredVersion doesn't exist return true.
     */
    public var isMinimumVersionSatisfied: Bool {
        if
            let minimumSdkForMinimumRequiredVersion = minimumSdkForMinimumRequiredVersion,
            minimumSdkForMinimumRequiredVersion > sdkVersion
        {
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
    public var metadata: [String : Any]? {
        return metadataObject
    }
}

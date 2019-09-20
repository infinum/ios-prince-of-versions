//
//  UpdateInfo.swift
//  Pods
//
//  Created by Jasmin Abou Aldan on 06/07/16.
//
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

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
    private var _minimumRequiredVersion: Version?
    private var _minimumSdkForMinimumRequiredVersion: Version?
    private var _latestVersion: Version
    private var _minimumSdkForLatestVersion: Version?
    private var _installedVersion: Version
    private var _sdkVersion: Version
    private var _metadata: [String: Any]?

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
        guard let data = data else {
            throw UpdateInfoError.invalidJsonData
        }
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary

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
            _minimumRequiredVersion = try? Version(string: minimumVersion)
        }
        
        // Minimum sdk for minimum version
        if let minimumSdkForMinimumVersionString = os["minimum_version_min_sdk"] as? String {
            _minimumSdkForMinimumRequiredVersion = try? Version(string: minimumSdkForMinimumVersionString)
        }

        // Latest version and notification type
        guard let latestVersionInfo = os["latest_version"] as? [String: AnyObject] else {
            throw UpdateInfoError.invalidLatestVersion
        }

        let notificationTypeString = (latestVersionInfo["notification_type"] as? String) ?? ""

        if let notificationTypeFromString = NotificationType(rawValue: notificationTypeString) {
            notificationType = notificationTypeFromString
        }

        if let versionString = latestVersionInfo["version"] as? String {
            _latestVersion = try Version(string: versionString)
        } else {
            throw UpdateInfoError.invalidLatestVersion
        }
        
        if let minimumSdkForLatestVersionString = latestVersionInfo["min_sdk"] as? String {
            _minimumSdkForLatestVersion = try? Version(string: minimumSdkForLatestVersionString)
        }

        // Installed version
        guard let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            throw UpdateInfoError.invalidCurrentVersion
        }
        guard let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            throw UpdateInfoError.invalidCurrentVersion   
        }

        _installedVersion = try Version(string: currentVersionString + "-" + currentBuildNumberString)

         #if os(iOS)
        _sdkVersion = try Version(string: UIDevice.current.systemVersion)
        #elseif os(macOS)
        _sdkVersion = try Version(string: ProcessInfo.processInfo.operatingSystemVersionString)
        #endif

        // Metadata
        _metadata = value["meta"] as? [String: Any]
    }

}

// MARK: - UpdateInfoValues -

extension UpdateInfo: UpdateInfoValues {

    /**
     Returns minimum required version of the app.
     */
    public var minimumRequiredVersion: Version? {
        return _minimumRequiredVersion
    }

    /**
     Returns minimum sdk for minimum required version of the app.
     */
    public var minimumSdkForMinimumRequiredVersion: Version? {
        return _minimumSdkForMinimumRequiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var latestVersion: Version {
        return _latestVersion
    }

    /**
     Returns sdk for latest available version of the app.
     */
    public var minimumSdkForLatestVersion: Version? {
        return _minimumSdkForLatestVersion
    }

    /**
     Returns installed version of the app.
     */
    public var installedVersion: Version {
        return _installedVersion
    }

    /**
     Returns sdk version of device.
     */
    public var sdkVersion: Version {
        return _sdkVersion
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

        guard let minimumRequiredVersion = minimumRequiredVersion else {
            return true
        }
        return installedVersion >= minimumRequiredVersion
    }

    /**
     Key-value pairs under "meta" key are optional metadata of which any amount can be sent accompanying the required fields.
     */
    public var metadata: [String : Any]? {
        return _metadata
    }
}

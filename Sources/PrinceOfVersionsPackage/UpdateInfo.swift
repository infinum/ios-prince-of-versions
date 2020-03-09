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

extension UpdateInfoValues {
    var minimumRequiredVersion: Version? { return nil }
    var minimumSdkForMinimumRequiredVersion: Version? { return nil }
    var isMinimumVersionSatisfied: Bool { return true }
    var metadata: [String: Any]? { return nil }
}

// MARK: - Internal configuration data -

public struct UpdateInfo {

    // MARK: - Private configuration -
    
    /// Data parsed from the configuration file
    private struct ConfigurationData {
        var minimumRequiredVersion: Version?
        var minimumSdkForMinimumRequiredVersion: Version?
        var latestVersion: Version?
        var minimumSdkForLatestVersion: Version?
        var installedVersion: Version?
        var sdkVersion: Version?
        var metadata: [String: Any]?
    }

    private var configurationData = ConfigurationData()

    // MARK: - Public notification type
    
    public enum NotificationType : String {
        case always = "ALWAYS"
        case once = "ONCE"
    }
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
            throw PrinceOfVersionsError.invalidJsonData
        }
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary

        // JSON data
        guard let value = json as? [String: AnyObject] else {
            throw PrinceOfVersionsError.invalidJsonData
        }

        #if os(iOS)
        guard let os = value["ios"] as? [String: AnyObject] else {
            throw PrinceOfVersionsError.invalidJsonData
        }

        #elseif os(macOS)
        guard let os = value["macos"] as? [String: AnyObject] else {
            throw PrinceOfVersionsError.invalidJsonData
        }
        #else
        throw PrinceOfVersionsError.invalidJsonData
        #endif

        // Minimum version
        if let minimumVersion = os["minimum_version"] as? String {
            configurationData.minimumRequiredVersion = try? Version(string: minimumVersion)
        }
        
        // Minimum sdk for minimum version
        if let minimumSdkForMinimumVersionString = os["minimum_version_min_sdk"] as? String {
            configurationData.minimumSdkForMinimumRequiredVersion = try? Version(string: minimumSdkForMinimumVersionString)
        }

        // Latest version and notification type
        guard let latestVersionInfo = os["latest_version"] as? [String: AnyObject] else {
            throw PrinceOfVersionsError.invalidLatestVersion
        }

        let notificationTypeString = (latestVersionInfo["notification_type"] as? String) ?? ""

        if let notificationTypeFromString = NotificationType(rawValue: notificationTypeString) {
            notificationType = notificationTypeFromString
        }

        if let versionString = latestVersionInfo["version"] as? String {
            configurationData.latestVersion = try Version(string: versionString)
        } else {
            throw PrinceOfVersionsError.invalidLatestVersion
        }
        
        if let minimumSdkForLatestVersionString = latestVersionInfo["min_sdk"] as? String {
            configurationData.minimumSdkForLatestVersion = try? Version(string: minimumSdkForLatestVersionString)
        }

        // Installed version
        guard let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            throw PrinceOfVersionsError.invalidCurrentVersion
        }
        guard let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            throw PrinceOfVersionsError.invalidCurrentVersion   
        }

        configurationData.installedVersion = try Version(string: currentVersionString + "-" + currentBuildNumberString)

         #if os(iOS)
        configurationData.sdkVersion = try Version(string: UIDevice.current.systemVersion)
        #elseif os(macOS)
        configurationData.sdkVersion = Version(macVersion: ProcessInfo.processInfo.operatingSystemVersion)
        #endif

        // Metadata
        configurationData.metadata = value["meta"] as? [String: Any]
    }

}

// MARK: - UpdateInfoValues -

extension UpdateInfo: UpdateInfoValues {

    /**
     Returns minimum required version of the app.
     */
    public var minimumRequiredVersion: Version? {
        return configurationData.minimumRequiredVersion
    }

    /**
     Returns minimum sdk for minimum required version of the app.
     */
    public var minimumSdkForMinimumRequiredVersion: Version? {
        return configurationData.minimumSdkForMinimumRequiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var latestVersion: Version {
        guard let version = configurationData.latestVersion else {
            preconditionFailure("Missing requred latest version data")
        }
        return version
    }

    /**
     Returns sdk for latest available version of the app.
     */
    public var minimumSdkForLatestVersion: Version? {
        return configurationData.minimumSdkForLatestVersion
    }

    /**
     Returns installed version of the app.
     */
    public var installedVersion: Version {
        guard let version = configurationData.installedVersion else {
            preconditionFailure("Unable to get installed version data")
        }
        return version
    }

    /**
     Returns sdk version of device.
     */
    public var sdkVersion: Version {
        guard let version = configurationData.sdkVersion else {
            preconditionFailure("Unable to get sdk version data")
        }
        return version
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
        return configurationData.metadata
    }
}

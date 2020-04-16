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

public struct UpdateInfo: Decodable {

    private let ios: ConfigurationData?
    private let macos: ConfigurationData?
    private let meta: [String: Id<Any>]?

    enum CodingKeys: String, CodingKey {
        case ios
        case macos
        case meta
    }

    private struct ConfigurationData: Codable {
        let minimumVersion: Version?
        let minimumSdkForMinimumRequiredVersion: Version?
        let latestVersion: LatestVersion?

        enum CodingKeys: String, CodingKey {
            case minimumVersion = "minimum_version"
            case minimumSdkForMinimumRequiredVersion = "minimum_version_min_sdk"
            case latestVersion = "latest_version"
        }
    }

    private struct LatestVersion: Codable {
        let version: Version?
        let notificationType: UpdateInfo.NotificationType?
        let minimumSdk: Version?

        enum CodingKeys: String, CodingKey {
            case version = "version"
            case notificationType = "notification_type"
            case minimumSdk = "min_sdk"
        }
    }

    // MARK: - Private properties -

    private var configurationForOS: ConfigurationData? {
        #if os(iOS)
        return ios
        #elseif os(macOS)
        return macos
        #endif
    }

    private var currentSdkVersion: Version? {
        #if os(iOS)
        return try Version(string: UIDevice.current.systemVersion)
        #elseif os(macOS)
        return Version(macVersion: ProcessInfo.processInfo.operatingSystemVersion)
        #endif
    }

    private let bundle = Bundle.main

    // MARK: - Public notification type

    public enum NotificationType: String, Codable {
        case always = "ALWAYS"
        case once = "ONCE"

        enum CodingKeys: CodingKey {
            case always
            case once
        }
    }

    // MARK: - Public properties

    /**
     Returns notification type.

     Possible values are:
     - Once: Show notification only once
     - Always: Show notification every time app run

     Default value is `.once`
     */
    public var notificationType: UpdateInfo.NotificationType {
        return configurationForOS?.latestVersion?.notificationType ?? .once
    }

    private var currentInstalledVersion: Version? {

        guard
            let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        else {
//            throw PrinceOfVersionsError.invalidCurrentVersion
            return nil
        }

        do {
            return try Version(string: currentVersionString + "-" + currentBuildNumberString)
        } catch _ {
            return nil
        }
    }
}

// MARK: - UpdateInfoValues -

extension UpdateInfo: UpdateInfoValues {

    /**
     Returns minimum required version of the app.
     */
    public var minimumRequiredVersion: Version? {
        return configurationForOS?.minimumVersion
    }

    /**
     Returns minimum sdk for minimum required version of the app.
     */
    public var minimumSdkForMinimumRequiredVersion: Version? {
        return configurationForOS?.minimumSdkForMinimumRequiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var latestVersion: Version {
//        throw PrinceOfVersionsError.invalidLatestVersion
        guard let version = configurationForOS?.latestVersion?.version else {
            preconditionFailure("Missing requred latest version data")
        }
        return version
    }

    /**
     Returns sdk for latest available version of the app.
     */
    public var minimumSdkForLatestVersion: Version? {
        return configurationForOS?.latestVersion?.minimumSdk
    }

    /**
     Returns installed version of the app.
     */
    public var installedVersion: Version {
        guard let version = currentInstalledVersion else {
            preconditionFailure("Unable to get installed version data")
        }
        return version
    }

    /**
     Returns sdk version of device.
     */
    public var sdkVersion: Version {
        guard let version = currentSdkVersion else {
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
        return meta?.mapValues { $0.raw }
    }
}

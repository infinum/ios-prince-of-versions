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

    // MARK: - Private properties -

    private let bundle = Bundle.main

    private var ios: Configurations?
    private var ios2: Configurations?
    private var macos: Configurations?
    private var macos2: Configurations?
    private var meta: [String: Id<Any>]?

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        // MARK: - V1
        if let value = decode(container: container, key: .ios, version: .v1) { ios = value }
        if let value = decode(container: container, key: .macos, version: .v1) { macos = value }

        // MARK: - V2
        if let value = decode(container: container, key: .ios, version: .v2) { ios = value }
        if let value = decode(container: container, key: .macos, version: .v2) { macos = value }
        if let value = decode(container: container, key: .ios2, version: .v2) { ios2 = value }
        if let value = decode(container: container, key: .macos2, version: .v2) { macos2 = value }

        #if os(iOS)
        if ios == nil && ios2 == nil { throw PrinceOfVersionsError.dataNotFound }
        #elseif os(macOS)
        if macos == nil && macos2 == nil { throw PrinceOfVersionsError.dataNotFound }
        #endif

        meta = try container.decode([String: Id<Any>].self, forKey: .meta)
    }

    private struct Configurations {
        let data: [ConfigurationData]
        let version: JSONVersion
    }

    private var jsonVersion: JSONVersion? {
        #if os(iOS)
        if ios?.version == .v2 { return .v2 }
        return ios2 == nil ? .v1 : .v2
        #elseif os(macOS)
        if macos?.version == .v2 { return .v2 }
        return macos2 == nil ? .v1 : .v2
        #endif
    }

    private var configurations: [ConfigurationData]? {
        #if os(iOS)
        #elseif os(macOS)
        #endif
    }

    private var configurationForOS: ConfigurationData? {
        #if os(iOS)
        #elseif os(macOS)
        #endif
    }

    var currentSdkVersion: Version? {
        #if os(iOS)
        return try Version(string: UIDevice.current.systemVersion)
        #elseif os(macOS)
        return Version(macVersion: ProcessInfo.processInfo.operatingSystemVersion)
        #endif
    }

    var currentVersionString: String? {
        return bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    var currentBuildNumberString: String? {
        return bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    var currentInstalledVersion: Version? {

        guard
            let currentVersionString = currentVersionString,
            let currentBuildNumberString = currentBuildNumberString
        else {
            return nil
        }

        do {
            return try Version(string: currentVersionString + "-" + currentBuildNumberString)
        } catch _ {
            return nil
        }
    }

    private func decode(container: KeyedDecodingContainer<CodingKeys>, key: CodingKeys, version: JSONVersion) -> Configurations? {

        let decodeForVersion: () throws -> Configurations? = {
            switch version {
            case .v1:
                if let value = try container.decodeIfPresent(ConfigurationDataV1.self, forKey: key) {
                    return Configurations(data: [value], version: .v1)
                }
            case .v2:
                if let value = try container.decodeIfPresent([ConfigurationDataV2].self, forKey: key) {
                    return Configurations(data: value, version: .v2)
                }
            }

            return nil
        }

        do { return try decodeForVersion() } catch _ { return nil }
    }

    enum CodingKeys: String, CodingKey {
        case ios
        case ios2
        case macos
        case macos2
        case meta
    }

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

    // MARK: - Public methods

    public func validate() -> PrinceOfVersionsError? {

        guard let configuration = configurationForOS else { return .invalidJsonData }

        guard
            let latestVersionInfo = configuration.latestVersion,
            latestVersionInfo.version != nil
        else {
            return .invalidLatestVersion
        }

        if currentVersionString == nil || currentBuildNumberString == nil {
            return .invalidCurrentVersion
        }

        return nil
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

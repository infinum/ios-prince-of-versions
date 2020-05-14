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

public protocol UpdateInfoValues {
    var requiredVersion: Version? { get }
    var lastVersionAvailable: Version? { get }
    var installedVersion: Version { get }
    var requirements: [String: Any]? { get }
}

// MARK: - Internal configuration data -

public struct UpdateInfo: Decodable {

    // MARK: - Private properties -

    private var ios: [ConfigurationData]?
    private var ios2: [ConfigurationData]?
    private var macos: [ConfigurationData]?
    private var macos2: [ConfigurationData]?
    private var meta: [String: AnyDecodable]?

    private let bundle = Bundle.main

    internal var configurations: [ConfigurationData]? {
        #if os(iOS)
        return ios ?? ios2
        #elseif os(macOS)
        return macos ?? macos2
        #endif
    }

    internal var configuration: ConfigurationData? {

        guard let configurations = configurations else { return nil }

        return configurations.first { configuration in
            guard
                let requiredOSVersion = configuration.requirements?.requiredOSVersion,
                let installedOSVersion = sdkVersion
            else { return false }
            return installedOSVersion >= requiredOSVersion && meetsUserRequirements(for: configuration)
        }
    }

    // MARK: - Internal properties -

    var sdkVersion: Version? {
        #if os(iOS)
        return try? Version(string: UIDevice.current.systemVersion)
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

        return try? Version(string: currentVersionString + "-" + currentBuildNumberString)
    }

    var metadata: [String: Any]? {

        guard let configMeta = configuration?.meta else {
            return meta?.mapValues { $0.value }
        }

        return meta?
            .merging(configMeta, uniquingKeysWith: { (_, newValue) in newValue })
            .mapValues { $0.value }
    }

    var userRequirements: [String: ((Any) -> Bool)] = [:]

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
        return configuration?.notifyLastVersionFrequency ?? .once
    }

    // MARK: - Init -

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        ios = container.decodeConfiguration(.ios)
        ios2 = container.decodeConfiguration(.ios2)
        macos = container.decodeConfiguration(.macos)
        macos2 = container.decodeConfiguration(.macos2)
        meta = container.decodeMeta(.meta)
    }

    // MARK: - Coding keys -

    enum CodingKeys: String, CodingKey {
        case ios, ios2, macos, macos2, meta
    }
}

// MARK: - Private methods -

extension UpdateInfo {

    private func meetsUserRequirements(for configuration: ConfigurationData) -> Bool {

        return userRequirements.reduce(true) { (result, requirement) -> Bool in

            let (key, checkRequirement) = requirement

            guard let valueForKey = configuration.requirements?.userDefinedRequirements[key] else {
                return false
            }

            return result && checkRequirement(valueForKey)
        }
    }
}

// MARK: - UpdateInfoValues -

extension UpdateInfo: UpdateInfoValues {

    /**
     Returns minimum required version of the app.
     */
    public var requiredVersion: Version? {
        return configuration?.requiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var lastVersionAvailable: Version? {
        return configuration?.lastVersionAvailable
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
     Returns requirements for configuration.
     */
    public var requirements: [String : Any]? {
        return configuration?.requirements?.allRequirements
    }
}

// MARK: - Helpers -

private extension KeyedDecodingContainer {
    
    func decodeConfiguration(_ key: K) -> [ConfigurationData]? {
        return try? decode([ConfigurationData].self, forKey: key)
    }

    func decodeMeta(_ key: K) -> [String: AnyDecodable]? {
        return try? decode([String: AnyDecodable].self, forKey: key)
    }
}

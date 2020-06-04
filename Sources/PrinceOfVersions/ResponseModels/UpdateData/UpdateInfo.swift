//
//  UpdateInfo.swift
//  PrinceOfVersions
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

// MARK: - Internal configuration data -

public struct UpdateInfo: Decodable {

    // MARK: - Private properties -

    private var ios: [ConfigurationData]?
    private var ios2: [ConfigurationData]?
    private var macos: [ConfigurationData]?
    private var macos2: [ConfigurationData]?
    private var meta: [String: AnyDecodable]?

    // MARK: - Internal properties -

    internal var bundle = Bundle.main

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
            return installedOSVersion >= requiredOSVersion && meetsUserRequirements(configuration.requirements)
        }
    }

    internal var sdkVersion: Version? {
        #if os(iOS)
        return try? Version(string: UIDevice.current.systemVersion)
        #elseif os(macOS)
        return Version(macVersion: ProcessInfo.processInfo.operatingSystemVersion)
        #endif
    }

    internal var currentInstalledVersion: Version? {

        guard
            let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        else {
            return nil
        }

        return try? Version(string: currentVersionString + "-" + currentBuildNumberString)
    }

    internal var metadata: [String: Any]? {

        guard let configMeta = configuration?.meta else {
            return meta?.mapValues { $0.value }
        }

        if let meta = meta {
            return meta
                .merging(configMeta, uniquingKeysWith: { (_, newValue) in newValue })
                .mapValues { $0.value }
        }

        return configMeta
    }

    internal var userRequirements: [String: ((Any) -> Bool)] = [:]

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

private extension UpdateInfo {

    func meetsUserRequirements(_ requirements: Requirements?) -> Bool {

        return userRequirements.allSatisfy { (key, checkRequirement) -> Bool in

            guard let valueForKey = requirements?.userDefinedRequirements[key] else {
                return false
            }

            return checkRequirement(valueForKey)
        }
    }
}

// MARK: - Public properties -

extension UpdateInfo: BaseUpdateInfo {

    /// Returns latest available version of the app.
    public var lastVersionAvailable: Version? {
        return configuration?.lastVersionAvailable
    }

    /// Returns installed version of the app.
    public var installedVersion: Version {
        guard let version = currentInstalledVersion else {
            preconditionFailure("Unable to get installed version data")
        }
        return version
    }
}

extension UpdateInfo {

    /// Returns minimum required version of the app.
    public var requiredVersion: Version? {
        return configuration?.requiredVersion
    }

    /// Returns requirements for configuration.
    public var requirements: [String : Any]? {
        return configuration?.requirements?.allRequirements
    }

    /// Returns notification frequency for configuration.
    public var notificationType: NotificationType {
        return configuration?.notifyLastVersionFrequency ?? .once
    }
}

// MARK: - Private helpers -

private extension KeyedDecodingContainer {
    
    func decodeConfiguration(_ key: K) -> [ConfigurationData]? {
        return try? decode([ConfigurationData].self, forKey: key)
    }

    func decodeMeta(_ key: K) -> [String: AnyDecodable]? {
        return try? decode([String: AnyDecodable].self, forKey: key)
    }
}

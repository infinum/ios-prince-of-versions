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
    // used only when supporting both PoV versions < 4.0, and versions >= 4.0
    // older version configuration is stored in ios property, and newer in ios2
    private var ios2: [ConfigurationData]?
    private var macos: [ConfigurationData]?
    // used only when supporting both PoV versions < 4.0, and versions >= 4.0
    // older version configuration is stored in macos property, and newer in macos2
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

    internal var configuration: ConfigurationData?

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

        if meta == nil && configuration?.meta == nil { return nil }

        let globalMeta = meta ?? [:]
        let configMeta = configuration?.meta ?? [:]

        return globalMeta
            .merging(configMeta, uniquingKeysWith: { (_, newValue) in newValue })
            .mapValues { $0.value }
    }

    internal var userRequirements: [String: ((Any) -> Bool)] = [:] {
        didSet {
            configuration = configurations?.first { meetsUserRequirements($0.requirements) }
        }
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

private extension UpdateInfo {

    var requiredOSVersionCheck: ((Any) -> Bool) {
        return { requiredOSVersion -> Bool in
            guard
                let installedOSVersion = self.sdkVersion,
                let requiredOSVersion = requiredOSVersion as? Version
            else { return true }
            return installedOSVersion >= requiredOSVersion
        }
    }

    func meetsUserRequirements(_ requirements: Requirements?) -> Bool {

        guard let requirements = requirements else { return true }

        var requirementChecks = userRequirements
        if requirements.shouldAddOSCheck {
            requirementChecks.updateValue(requiredOSVersionCheck, forKey: "requiredOsVersion")
        }

        return requirements.allRequirements?.allSatisfy {
            guard let checkRequirement = requirementChecks[$0.key] else { return false }
            return checkRequirement($0.value)
        } ?? true
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

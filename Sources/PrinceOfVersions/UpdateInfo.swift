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

    private var configurations: [ConfigurationData]? {
        #if os(iOS)
        return ios != nil ? ios : ios2
        #elseif os(macOS)
        return macos != nil ? macos : macos2
        #endif
    }

    private var configurationForOS: ConfigurationData? {

        guard let configurations = configurations else { return nil }

        return configurations.first { configuration in
            guard
                let requiredOSVersion = configuration.requirements?.requiredOSVersion,
                let sdkVersion = sdkVersion
            else { return false }
            return sdkVersion >= requiredOSVersion && meetsUserRequirements(for: configuration)
        }
    }

    // MARK: - Internal properties -

    var sdkVersion: Version? {
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

    var metadata: [String: Any]? {

        guard let configMeta = configurationForOS?.meta else {
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
        return configurationForOS?.notificationType ?? .once
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
        case ios
        case ios2
        case macos
        case macos2
        case meta
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

            return checkRequirement(valueForKey)
        }
    }
}

// MARK: - Internal methods -

extension UpdateInfo {

    func validate() -> PrinceOfVersionsError? {

        if configurations == nil {
            return .dataNotFound
        }

        if configurations != nil && configurationForOS == nil {
            return .requirementsNotSatisfied(nil)
        }

        if currentInstalledVersion == nil {
            return .invalidCurrentVersion
        }

        if lastVersionAvailable == nil {
            return .invalidLatestVersion
        }

        if requiredVersion == nil {
            return .invalidMinimumVersion
        }

        return nil
    }
}

// MARK: - UpdateInfoData -

extension UpdateInfo: UpdateInfoValues {

    /**
     Returns minimum required version of the app.
     */
    public var requiredVersion: Version? {
        return configurationForOS?.requiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var lastVersionAvailable: Version? {
        return configurationForOS?.lastVersionAvailable
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
        return configurationForOS?.requirements?.allRequirements
    }
}

// MARK: - Helpers -

private extension KeyedDecodingContainer {
    
    func decodeConfiguration(_ key: K) -> [ConfigurationData]? {
        do { return try decode([ConfigurationData].self, forKey: key) }
        catch _ { }
        return nil
    }

    func decodeMeta(_ key: K) -> [String: AnyDecodable]? {
        do { return try decode([String: AnyDecodable].self, forKey: key) }
        catch _ { }
        return nil
    }
}

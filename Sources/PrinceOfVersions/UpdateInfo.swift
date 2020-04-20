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

    private let bundle = Bundle.main

    private let ios: [ConfigurationData]?
    private let ios2: [ConfigurationData]?
    private let macos: [ConfigurationData]?
    private let macos2: [ConfigurationData]?
    private let meta: [String: AnyDecodable]?

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
        guard let configurationMeta = configurationForOS?.meta else { return meta?.mapValues { $0.value } }
        return meta?.merging(configurationMeta, uniquingKeysWith: { (current, _) in current }).mapValues { $0.value }
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

    // MARK: - Initialization -

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            ios = try container.decode([ConfigurationData].self, forKey: .ios)
        } catch _ {
            ios = nil
        }

        do {
            ios2 = try container.decode([ConfigurationData].self, forKey: .ios2)
        } catch _ {
            ios2 = nil
        }

        do {
            macos = try container.decode([ConfigurationData].self, forKey: .macos)
        } catch _ {
            macos = nil
        }

        do {
            macos2 = try container.decode([ConfigurationData].self, forKey: .macos2)
        } catch _ {
            macos2 = nil
        }

        do {
            meta = try container.decode([String: AnyDecodable].self, forKey: .meta)
        } catch _ {
            meta = nil
        }
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
        return configurationForOS?.requirements?.userDefinedRequirements
    }
}

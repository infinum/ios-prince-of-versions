//
//  AppStoreInfo.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 06/02/2020.
//  Copyright © 2020 Infinum Ltd. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct AppStoreInfo: Codable {

    // MARK: - Internal properties -

    static internal var bundle: Bundle = .main

    internal let resultCount: Int?
    internal let results: [ConfigurationData]

    internal var configurationData: ConfigurationData? {
        var configurationData = results.first
        configurationData?.bundle = AppStoreInfo.bundle
        return configurationData
    }

    // MARK: - ConfigData Struct -

    internal struct ConfigurationData: Codable {

        var version: Version?
        var minimumOsVersion: Version?
        var currentVersionReleaseDate: String?

        var bundle: Bundle = .main

        var installedVersion: Version? {

            guard
                let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
                let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            else {
                return nil
            }

            return try? Version(string: currentVersionString + "-" + currentBuildNumberString)
        }

        var releaseDate: Date? {
            return currentVersionReleaseDate.flatMap { ConfigurationData.dateFormatter.date(from: $0) }
        }

        var sdkVersion: Version? {
            #if os(iOS)
            do { return try Version(string: UIDevice.current.systemVersion) } catch { return nil }
            #elseif os(macOS)
            return Version(macVersion: ProcessInfo.processInfo.operatingSystemVersion)
            #endif
        }

        private static var dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return dateFormatter
        }()

        private enum CodingKeys: String, CodingKey {
            case version, minimumOsVersion, currentVersionReleaseDate
        }
    }

    internal var phaseReleaseInProgress: Bool {
        guard
            let releaseDate = configurationData?.releaseDate,
            let finishDate = Calendar.current.date(byAdding: .day, value: 7, to: releaseDate)
        else { return false }
        return finishDate > Date()
    }

    internal var versionInfoValues: UpdateInfo {
        return UpdateInfo(
            updateData: self,
            sdkVersion: configurationData?.sdkVersion,
            phaseReleaseInProgress: phaseReleaseInProgress
        )
    }

    // MARK: - CodingKeys -

    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
}

// MARK: - AppStoreInfoValues -

extension AppStoreInfo: UpdateInfoValues {

    /// Returns minimum required version of the app.
    public var requiredVersion: Version? {
        return configurationData?.installedVersion
    }

    /// Returns latest available version of the app.
    public var lastVersionAvailable: Version? {
        return configurationData?.version
    }

    /// Returns requirements for configuration.
    public var requirements: [String : Any]? {
        return nil
    }

    /// Returns installed version of the app.
    public var installedVersion: Version {
        guard let version = configurationData?.installedVersion else {
            preconditionFailure("Unable to get installed version data")
        }
        return version
    }
}

// MARK: - AppStoreResultValues -

extension AppStoreInfo: UpdateResultValues {

    /// The biggest version it is possible to update to, or current version of the app if it isn't possible to update
    public var updateVersion: Version {

        guard let latestVersion = configurationData?.version else {
            preconditionFailure("Unable to get version data")
        }

        return Version.max(latestVersion, installedVersion)
    }

    /// Resolution of the update check
    public var updateState: UpdateStatus {

        guard let latestVersion = configurationData?.version else {
            return .noUpdateAvailable
        }

        return latestVersion > installedVersion ? .newUpdateAvailable : .noUpdateAvailable
    }

    /// Update configuration values used to check
    public var versionInfo: UpdateInfo {
        return versionInfoValues
    }

    public var metadata: [String : Any]? {
        return nil
    }
}

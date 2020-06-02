//
//  AppStoreUpdateInfo.swift
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

public struct AppStoreUpdateInfo: Codable {

    // MARK: - Internal properties -

    static internal var bundle: Bundle = .main

    internal let resultCount: Int?
    internal let results: [ConfigurationData]

    internal var configurationData: ConfigurationData? {
        var configurationData = results.first
        configurationData?.bundle = AppStoreUpdateInfo.bundle
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

    // MARK: - CodingKeys -

    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
}

// MARK: - Public properties -

extension AppStoreUpdateInfo: BaseUpdateInfo {

    /// Returns latest available version of the app.
    public var lastVersionAvailable: Version? {
        return configurationData?.version
    }

    /// Returns installed version of the app.
    public var installedVersion: Version {
        guard let version = configurationData?.installedVersion else {
            preconditionFailure("Unable to get installed version data")
        }
        return version
    }
}

extension AppStoreUpdateInfo {

    public var releaseDate: Date? {
        return configurationData?.releaseDate
    }
}

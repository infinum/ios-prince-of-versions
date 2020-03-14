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

public struct AppStoreInfo {

    // MARK: - Private configuration

    /// Data parsed from the configuration file
    private struct ConfigurationData {
        var latestVersion: Version?
        var minimumSdkForLatestVersion: Version?
        var installedVersion: Version?
        var sdkVersion: Version?
    }

    private var configurationData = ConfigurationData()
    private let currentVersionReleaseDate: Date?

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

        guard
            let resultCount = value["resultCount"] as? Int,
            resultCount > 0
        else {
            throw PrinceOfVersionsError.dataNotFound
        }

        guard
            let arrayOfResults = value["results"] as? [[String: AnyObject]],
            let results = arrayOfResults.first // Get only first result for queried bundle id
        else {
            throw PrinceOfVersionsError.invalidJsonData
        }

        // Latest version

        if let versionString = results["version"] as? String {
            configurationData.latestVersion = try Version(string: versionString)
        } else {
            throw PrinceOfVersionsError.invalidLatestVersion
        }

        if let minimumSdkForLatestVersionString = results["minimumOsVersion"] as? String {
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

        // Release date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let releaseDate = results["currentVersionReleaseDate"] as? String
        currentVersionReleaseDate = releaseDate.flatMap {
            dateFormatter.date(from: $0)
        }
    }

}

// MARK: - AppStoreInfoValues -

extension AppStoreInfo: UpdateInfoValues {

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
     Returns bool value if phased release period is in progress

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value send by `itunes.apple.com` API.
     */
    public var phaseReleaseInProgress: Bool {
        guard
            let currentReleaseDate = currentVersionReleaseDate,
            let finishDate = Calendar.current.date(byAdding: .day, value: 7, to: currentReleaseDate)
        else { return false }
        return finishDate > Date()
    }
}

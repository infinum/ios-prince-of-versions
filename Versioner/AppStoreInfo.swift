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

    var bundle: Bundle = .main

    private let resultCount: Int
    private let results: [ConfigurationData]

    private var configurationData: ConfigurationData? { // results.count == 0 -> throw PrinceOfVersionsError.dataNotFound
        var configurationData = results.first
        configurationData?.bundle = bundle
        return configurationData
    }

    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }

    private struct ConfigurationData: Codable {

        var bundle: Bundle = .main

        var latestVersion: Version? // throw PrinceOfVersionsError.invalidLatestVersion
        var minimumSdkForLatestVersion: Version?
        var releaseDate: String?

        var installedVersion: Version? {

            guard
                let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
                let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            else {
                //throw PrinceOfVersionsError.invalidCurrentVersion
                return nil
            }

            do {
                return try Version(string: currentVersionString + "-" + currentBuildNumberString)
            } catch _ {
                return nil
            }
        }

        var currentVersionReleaseDate: Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return releaseDate.flatMap { dateFormatter.date(from: $0) }
        }

        var sdkVersion: Version? {
            #if os(iOS)
            return try Version(string: UIDevice.current.systemVersion)
            #elseif os(macOS)
            return Version(macVersion: ProcessInfo.processInfo.operatingSystemVersion)
            #endif
        }

        enum CodingKeys: String, CodingKey {
            case latestVersion = "version"
            case minimumSdkForLatestVersion = "minimumOsVersion"
            case releaseDate = "currentVersionReleaseDate"
        }
    }
}

// MARK: - AppStoreInfoValues -

extension AppStoreInfo: UpdateInfoValues {

    /**
     Returns latest available version of the app.
     */
    public var latestVersion: Version {
        guard let version = configurationData?.latestVersion else {
            preconditionFailure("Missing requred latest version data")
        }
        return version
    }

    /**
     Returns sdk for latest available version of the app.
     */
    public var minimumSdkForLatestVersion: Version? {
        return configurationData?.minimumSdkForLatestVersion
    }

    /**
     Returns installed version of the app.
     */
    public var installedVersion: Version {
        guard let version = configurationData?.installedVersion else {
            preconditionFailure("Unable to get installed version data")
        }
        return version
    }

    /**
     Returns sdk version of device.
     */
    public var sdkVersion: Version {
        guard let version = configurationData?.sdkVersion else {
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
            let currentReleaseDate = configurationData?.currentVersionReleaseDate,
            let finishDate = Calendar.current.date(byAdding: .day, value: 7, to: currentReleaseDate)
        else { return false }
        return finishDate > Date()
    }
}

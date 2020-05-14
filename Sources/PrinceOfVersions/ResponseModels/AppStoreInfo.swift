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

    internal var bundle: Bundle = .main

    internal let resultCount: Int?
    internal let results: [ConfigurationData]

    internal var configurationData: ConfigurationData? {
        var configurationData = results.first
        configurationData?.bundle = bundle
        return configurationData
    }

    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }

    internal struct ConfigurationData: Codable {

        var latestVersion: Version?
        var minimumOsVersion: Version?
        var currentVersionReleaseDate: String?

        var bundle: Bundle = .main

        var currentVersionString: String? {
            return bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        }

        var currentBuildNumberString: String? {
            return bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        }

        var installedVersion: Version? {

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
            case latestVersion, minimumOsVersion, currentVersionReleaseDate
        }
    }
}
//
//// MARK: - AppStoreInfoValues -
//
//extension AppStoreInfo: UpdateResultValues {
//
//    var updateVersion: Version {
//        return installedVersion
//    }
//
//    var updateState: UpdateStatus {
//        return .newUpdateAvailable
//    }
//
//    var versionInfo: UpdateInfo {
//        return self
//    }
//
//    var metadata: [String : Any]? {
//        return nil
//    }
//
//    /**
//     Returns bool value if phased release period is in progress
//
//     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value send by `itunes.apple.com` API.
//     */
//    public var phaseReleaseInProgress: Bool {
//        guard
//            let releaseDate = configurationData?.releaseDate,
//            let finishDate = Calendar.current.date(byAdding: .day, value: 7, to: releaseDate)
//        else { return false }
//        return finishDate > Date()
//    }
//}
//
//extension AppStoreInfo: UpdateInfoValues {
//
//    /**
//     Returns minimum required version of the app.
//     */
//    public var requiredVersion: Version? {
//        return configurationData?.installedVersion
//    }
//
//    /**
//     Returns latest available version of the app.
//     */
//    public var lastVersionAvailable: Version? {
//        return configurationData?.latestVersion
//    }
//
//    /**
//     Returns requirements for configuration.
//     */
//    public var requirements: [String : Any]? {
//        return nil
//    }
//
//    /**
//     Returns installed version of the app.
//     */
//    public var installedVersion: Version {
//        guard let version = configurationData?.installedVersion else {
//            preconditionFailure("Unable to get installed version data")
//        }
//        return version
//    }
//}

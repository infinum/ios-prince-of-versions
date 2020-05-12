//
//  PoVError.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 14/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

public enum PoVError: Error {
    case invalidJsonData
    case dataNotFound
    case requirementsNotSatisfied([String: Any]?)
    case missingConfigurationVersion
    case invalidCurrentVersion
    case invalidBundleId
    case unknown(String?)
}

extension PoVError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .invalidJsonData:
            return NSLocalizedString("Invalid JSDON Data", comment: "")
        case .dataNotFound:
            return NSLocalizedString("Data not found for selected app id", comment: "")
        case .requirementsNotSatisfied:
            return NSLocalizedString("Requirements not satisfied", comment: "")
        case .missingConfigurationVersion:
            return NSLocalizedString("Missing configuration version", comment: "")
        case .invalidCurrentVersion:
            return NSLocalizedString("Invalid Current Version", comment: "")
        case .invalidBundleId:
            return NSLocalizedString("BundleID not found", comment: "")
        case .unknown(let customMessage):
            guard let message = customMessage else {
                return NSLocalizedString("Unknown error", comment: "")
            }
            return  NSLocalizedString(message, comment: "")
        }
    }
}

// MARK: - Validation methods -

extension PoVError {

    static func validate(updateInfo: UpdateInfo) -> PoVError? {

        if updateInfo.configurations == nil {
            return .dataNotFound
        }

        if updateInfo.configurations != nil && updateInfo.configuration == nil {
            return .requirementsNotSatisfied(updateInfo.metadata)
        }

        if updateInfo.lastVersionAvailable == nil && updateInfo.requiredVersion == nil {
            return .missingConfigurationVersion
        }

        if updateInfo.currentInstalledVersion == nil {
            return .invalidCurrentVersion
        }

        return nil
    }

    static func validate(appStoreInfo: AppStoreInfo) -> PoVError? {

        guard let resultCount = appStoreInfo.resultCount, resultCount > 0 else { return .dataNotFound }

        guard let configuration = appStoreInfo.configurationData else { return .invalidJsonData }

        if configuration.latestVersion == nil { return .missingConfigurationVersion }

        if configuration.currentVersionString == nil || configuration.currentBuildNumberString == nil {
            return .invalidCurrentVersion
        }

        return nil
    }
}

//
//  PrinceOfVersionsError.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 14/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

public enum PrinceOfVersionsError: Error {
    case invalidJsonData
    case dataNotFound
    case requirementsNotSatisfied([String: Any]?)
    case missingConfigurationVersion
    case invalidCurrentVersion
    case invalidBundleId
    case unknown(String?)
}

extension PrinceOfVersionsError: LocalizedError {

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

//
//  PrinceOfVersionsError.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 14/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

public enum UpdateInfoError: Error {
    case invalidJsonData
    case invalidLatestVersion
    case invalidCurrentVersion
    case unknown(String?)
}

extension UpdateInfoError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .invalidJsonData:
            return NSLocalizedString("Invalid JSDON Data", comment: "")
        case .invalidLatestVersion:
            return NSLocalizedString("Invalid Latest Version", comment: "")
        case .invalidCurrentVersion:
            return NSLocalizedString("Invalid Current Version", comment: "")
        case .unknown(let customMessage):
            guard let message = customMessage else {
                return NSLocalizedString("Unknown error", comment: "")
            }
            return  NSLocalizedString(message, comment: "")
        }
    }
}

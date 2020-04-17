//
//  ConfigurationDataV1.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 16/04/2020.
//  Copyright © 2020 Infinum Ltd. All rights reserved.
//

import Foundation

struct ConfigurationDataV1: ConfigurationData, Codable {

    let minimumVersion: Version?
    let minimumSdkForMinimumRequiredVersion: Version?
    let latestVersion: LatestVersion?

    var version: JSONVersion {
        return .v1
    }

    enum CodingKeys: String, CodingKey {
        case minimumVersion = "minimum_version"
        case minimumSdkForMinimumRequiredVersion = "minimum_version_min_sdk"
        case latestVersion = "latest_version"
    }

    func validate() -> PrinceOfVersionsError? {
        return nil
    }
}

struct LatestVersion: Codable {

    let version: Version?
    let notificationType: UpdateInfo.NotificationType
    let minimumSdk: Version?

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case notificationType = "notification_type"
        case minimumSdk = "min_sdk"
    }
}

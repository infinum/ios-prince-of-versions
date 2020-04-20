//
//  ConfigurationData.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 16/04/2020.
//  Copyright © 2020 Infinum Ltd. All rights reserved.
//

import Foundation

struct ConfigurationData: Decodable {

    let requiredVersion: Version?
    let lastVersionAvailable: Version?
    let notificationType: UpdateInfo.NotificationType?
    let requirements: Requirements?
    let meta: [String: AnyDecodable]?

    enum CodingKeys: String, CodingKey {
        case requiredVersion = "required_version"
        case lastVersionAvailable = "last_version_available"
        case notificationType = "notify_last_version_frequency"
        case requirements
        case meta
    }

    func validate() -> PrinceOfVersionsError? {
        return nil
    }
}

struct Requirements: Decodable {

    let requiredOSVersion: Version?
    var userDefinedRequirements: [String: Any]

    enum CodingKeys: String, CodingKey {
        case requiredOSVersion = "required_os_version"
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        requiredOSVersion = try container.decode(Version.self, forKey: .requiredOSVersion)

        userDefinedRequirements = [:]

        let dynamicKeysContainer = try decoder.container(keyedBy: DynamicKey.self)

        dynamicKeysContainer.allKeys.forEach {
            guard
                $0.stringValue != CodingKeys.requiredOSVersion.rawValue,
                let value = dynamicKeysContainer.getValue(for: $0)
            else { return }

            userDefinedRequirements.updateValue(value, forKey: $0.stringValue)
        }
    }
}

private extension KeyedDecodingContainer {

    func getValue(for key: K) -> AnyDecodable? {
        do { return try decodeIfPresent(AnyDecodable.self, forKey: key) }
        catch _ { }
        return nil
    }
}

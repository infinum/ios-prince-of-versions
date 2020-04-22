//
//  ConfigurationData.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 16/04/2020.
//  Copyright © 2020 Infinum Ltd. All rights reserved.
//

import Foundation

// MARK: - ConfigurationData -
struct ConfigurationData: Decodable {

    // MARK: - Internal properties
    let requiredVersion: Version?
    let lastVersionAvailable: Version?
    let notificationType: UpdateInfo.NotificationType?
    let requirements: Requirements?
    let meta: [String: AnyDecodable]?

    // MARK: - Coding keys
    enum CodingKeys: String, CodingKey {
        case requiredVersion = "required_version"
        case lastVersionAvailable = "last_version_available"
        case notificationType = "notify_last_version_frequency"
        case requirements
        case meta
    }
}

// MARK: - Requirements -
struct Requirements: Decodable {

    // MARK: - Internal properties
    let requiredOSVersion: Version?
    var userDefinedRequirements: [String: Any]

    var allRequirements: [String: Any]? {
        guard let requiredOSVersion = requiredOSVersion else { return nil }
        var requirements: [String : Any] = [:]
        requirements.updateValue(requiredOSVersion, forKey: CodingKeys.requiredOSVersion.rawValue)
        return requirements.merging(userDefinedRequirements, uniquingKeysWith: { (_, newValue) in newValue })
    }

    // MARK: - Init
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

            userDefinedRequirements.updateValue(value.value, forKey: $0.stringValue)
        }
    }

    // MARK: - Coding keys
    enum CodingKeys: String, CodingKey {
        case requiredOSVersion = "required_os_version"
    }
}

// MARK: - Helpers -

private extension KeyedDecodingContainer {

    func getValue(for key: K) -> AnyDecodable? {
        return try? decode(AnyDecodable.self, forKey: key)
    }
}

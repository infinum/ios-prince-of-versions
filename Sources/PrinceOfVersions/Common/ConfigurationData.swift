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
    let requiredVersion: Version?
    let lastVersionAvailable: Version?
    let notifyLastVersionFrequency: NotificationType?
    let requirements: Requirements?
    let meta: [String: AnyDecodable]?
}

// MARK: - Requirements -

struct Requirements: Decodable {

    // MARK: - Internal properties

    let requiredOSVersion: Version?
    var userDefinedRequirements: [String: Any]

    var allRequirements: [String: Any]? {
        var requirements = userDefinedRequirements
        if let requiredOSVersion = requiredOSVersion {
            requirements.updateValue(requiredOSVersion, forKey: CodingKeys.requiredOSVersion.rawValue)
        }
        return requirements
    }

    // MARK: - Init

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        requiredOSVersion = try? container.decode(Version.self, forKey: .requiredOSVersion)

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
        case requiredOSVersion = "requiredOsVersion"
    }
}

// MARK: - Helpers -

private extension KeyedDecodingContainer {

    func getValue(for key: K) -> AnyDecodable? {
        return try? decode(AnyDecodable.self, forKey: key)
    }
}

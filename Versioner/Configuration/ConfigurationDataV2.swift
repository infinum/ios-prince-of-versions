//
//  ConfigurationDataV2.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 16/04/2020.
//  Copyright © 2020 Infinum Ltd. All rights reserved.
//

import Foundation

struct ConfigurationDataV2: ConfigurationData, Decodable {

    let requiredVersion: Version?
    let lastVersionAvailable: Version?
    let notificationType: UpdateInfo.NotificationType?
    let requirements: Requirements

    var version: JSONVersion {
        return .v2
    }

    enum CodingKeys: String, CodingKey {
        case requiredVersion = "required_version"
        case lastVersionAvailable = "last_version_available"
        case notificationType = "notify_last_version_frequency"
        case requirements
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
        try dynamicKeysContainer.allKeys.forEach {
            guard let value = try dynamicKeysContainer.getValue(for: $0) else { return }
            userDefinedRequirements.updateValue(value, forKey: $0.stringValue)
        }

    }
}

private struct DynamicKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}

private extension KeyedDecodingContainer {

    func getValue(for key: K) throws -> Any? {

        if let stringValue = try decodeIfPresent(String.self, forKey: key) {
            return stringValue
        }

        if let integerValue = try decodeIfPresent(Int.self, forKey: key) {
            return integerValue
        }

        if let boolValue = try decodeIfPresent(Bool.self, forKey: key) {
            return boolValue
        }

        if try decodeNil(forKey: key) {
            return true
        }

        return nil
    }
}

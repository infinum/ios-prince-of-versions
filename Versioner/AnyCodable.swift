//
//  AnyCodable.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 15/04/2020.
//  Copyright © 2020 Infinum Ltd. All rights reserved.
//

import Foundation

public struct Id<Entity>: Hashable {
    public let raw: String
    public init(_ raw: String) {
        self.raw = raw
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(raw)
    }

    public static func == (lhs: Id, rhs: Id) -> Bool {
        return lhs.raw == rhs.raw
    }
}

extension Id: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if raw.isEmpty {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot initialize Id from an empty string"
            )
        }
        self.init(raw)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(raw)
    }
}

//
//  CaseInsensitiveDecodable.swift
//  PrinceOfVersions
//
//  Created by Nikola Simunko on 29.06.2026..
//


public protocol CaseInsensitiveDecodable: RawRepresentable, Decodable where RawValue == String {}

extension CaseInsensitiveDecodable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let raw = try container.decode(String.self)
		
		guard let value = Self(rawValue: raw.uppercased()) else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "Cannot initialize \(Self.self) from '\(raw)'"
			)
		}
		self = value
	}
}

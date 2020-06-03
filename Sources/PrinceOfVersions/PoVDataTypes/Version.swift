//
//  Version.swift
//  PrinceOfVersions
//
//  Created by Filip Beć on 10/10/16.
//  Copyrhs © 2016 Infinum Ltd. All rights reserved.
//

import Foundation

public enum VersionError: Error {
    case invalidString
    case invalidMajorVersion
}

public class Version: NSObject, Codable {
    @objc public var major: Int
    @objc public var minor: Int
    @objc public var patch: Int = 0
    @objc public var build: Int = 0

    public var wasNotified: Bool {
        return UserDefaults.standard.bool(forKey: versionUserDefaultKey)
    }

    private var versionUserDefaultKey: String {
        return "co.infinum.prince-of-versions.version-" + self.description
    }

    @objc public func markNotified() {
        UserDefaults.standard.set(true, forKey: versionUserDefaultKey)
    }

    required public init(from decoder: Decoder) throws {
        major = 0
        minor = 0
        super.init()
        let string = try decoder.singleValueContainer().decode(String.self)
        try configure(with: string)
    }

    init(string: String) throws {
        major = 0
        minor = 0
        super.init()
        try configure(with: string)
    }

    #if os(macOS)
    init(macVersion: OperatingSystemVersion) {
        major = macVersion.majorVersion
        minor = macVersion.minorVersion
        patch = macVersion.patchVersion
    }
    #endif

    private func configure(with string: String) throws {
        let versionBuildComponents = string.components(separatedBy: "-")
        guard let versionComponents = versionBuildComponents.first?.components(separatedBy: ".") else {
            throw VersionError.invalidString
        }
        guard !versionComponents.isEmpty else {
            throw VersionError.invalidString
        }

        if versionBuildComponents.count > 1 {
            build = Version.number(from: versionBuildComponents, atIndex: 1) ?? 0
        }

        if let majorVersion = Version.number(from: versionComponents, atIndex: 0) {
            major = majorVersion
        } else {
            throw VersionError.invalidMajorVersion
        }

        minor = Version.number(from: versionComponents, atIndex: 1) ?? 0
        patch = Version.number(from: versionComponents, atIndex: 2) ?? 0
    }

    private static func number(from components: [String], atIndex index: Int) -> Int? {
        guard components.indices.contains(index) else {
            return nil
        }
        return Int(components[index])
    }

    @objc override public var description: String {
        return "\(major).\(minor).\(patch)-\(build)"
    }
}

// MARK: - Comparison -

extension Version {

    @objc(isGreaterThanVersion:)
    public func isGreaterThan(_ version: Version) -> Bool {
        return self > version
    }

    @objc(isGreaterOrEqualToVersion:)
    public func isGreaterOrEqualTo(_ version: Version) -> Bool {
        return self >= version
    }

    @objc(isLowerOrEqualToVersion:)
    public func isLowerOrEqualTo(_ version: Version) -> Bool {
        return self <= version
    }

    @objc(isEqualToVersion:)
    public func isEqualTo(_ version: Version) -> Bool {
        return self == version
    }

    @objc(isNotEqualToVersion:)
    public func isNotEqualTo(_ version: Version) -> Bool {
        return self != version
    }

    public static func max(_ version1: Version, _ version2: Version) -> Version {
        return version1.isGreaterThan(version2) ? version1 : version2
    }
}

extension Version: Comparable {

    private var tuple: (Int, Int, Int, Int) {
        return (major, minor, patch, build)
    }

    public static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.tuple == rhs.tuple
    }

    static func != (lhs: Version, rhs: Version) -> Bool {
        return !(lhs == rhs)
    }

    public static func < (lhs: Version, rhs: Version) -> Bool {
        return lhs.tuple < rhs.tuple
    }

    public static func <= (lhs: Version, rhs: Version) -> Bool {
        return lhs.tuple <= rhs.tuple
    }

    public static func > (lhs: Version, rhs: Version) -> Bool {
        return lhs.tuple > rhs.tuple
    }

    public static func >= (lhs: Version, rhs: Version) -> Bool {
        return lhs.tuple >= rhs.tuple
    }

}

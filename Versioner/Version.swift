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

public struct Version {
    public var major: Int
    public var minor: Int
    public var patch: Int
    public var build: Int = 0

    var wasNotified: Bool {
        get {
            return UserDefaults.standard.bool(forKey: versionUserDefaultKey)
        }
    }

    private var versionUserDefaultKey: String {
        return "co.infinum.prince-of-versions.version-" + self.description
    }

    public func markNotified() {
        UserDefaults.standard.set(true, forKey: versionUserDefaultKey)
    }

    init(string: String) throws {
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

        if let _major = Version.number(from: versionComponents, atIndex: 0) {
            major = _major
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

}

extension Version: CustomStringConvertible {
    public var description: String {
        return "\(major).\(minor).\(patch)-\(build)"
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

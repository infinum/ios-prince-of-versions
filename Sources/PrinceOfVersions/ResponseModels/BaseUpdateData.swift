//
//  BaseUpdateData.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 02/06/2020.
//

import Foundation

@objc
public enum UpdateStatus: Int {
    case noUpdateAvailable
    case requiredUpdateNeeded
    case newUpdateAvailable
}

public protocol BaseUpdateResult {
    associatedtype BaseInfo: BaseUpdateInfo
    var updateVersion: Version { get }
    var updateState: UpdateStatus { get }
    var updateInfo: BaseInfo { get }
}

public protocol BaseUpdateInfo {
    var lastVersionAvailable: Version? { get }
    var installedVersion: Version { get }
}

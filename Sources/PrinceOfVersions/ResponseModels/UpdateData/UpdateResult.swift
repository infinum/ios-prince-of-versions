//
//  UpdateResult.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 17/04/2020.
//

import Foundation

// MARK: - Public notification type

public enum NotificationType: String, Codable {
    case always = "ALWAYS"
    case once = "ONCE"

    enum CodingKeys: CodingKey {
        case always
        case once
    }
}

public enum UpdateStatus {
    case noUpdateAvailable
    case requiredUpdateNeeded
    case newUpdateAvailable
}

public protocol UpdateResultValues {
    var updateVersion: Version { get }
    var updateState: UpdateStatus { get }
    var versionInfo: UpdateInfo { get }
    var metadata: [String: Any]? { get }
}

public struct UpdateInfo {
    public var updateInfo: UpdateInfoValues
    public var sdkVersion: Version?
    /**
     Returns notification type.

     Possible values are:
     - Once: Show notification only once
     - Always: Show notification every time app run

     Default value is `.once`
     */
    public var notificationType: NotificationType

    /**
     Returns bool value if phased release period is in progress

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value send by `itunes.apple.com` API.
     */
    public var phaseReleaseInProgress: Bool?
}

public struct UpdateResult {

    // MARK: - Private properties
    private var updateInfoResponse: UpdateInfoResponse

    // MARK: - Init
    init(updateInfoResponse: UpdateInfoResponse) {
        self.updateInfoResponse = updateInfoResponse
    }

}

// MARK: - UpdateResultValues -

extension UpdateResult: UpdateResultValues {

    public var updateVersion: Version {

        if let requiredVersion = updateInfoResponse.requiredVersion, let lastVersionAvailable = updateInfoResponse.lastVersionAvailable {
            return Version.max(requiredVersion, lastVersionAvailable)
        }

        if let requiredVersion = updateInfoResponse.requiredVersion, updateInfoResponse.lastVersionAvailable == nil {
            return Version.max(requiredVersion, updateInfoResponse.installedVersion)
        }

        if updateInfoResponse.requiredVersion == nil, let lastVersionAvailable = updateInfoResponse.lastVersionAvailable {
            return Version.max(lastVersionAvailable, updateInfoResponse.installedVersion)
        }

        return updateInfoResponse.installedVersion
    }

    public var updateState: UpdateStatus {

        if let requiredVersion = updateInfoResponse.requiredVersion, requiredVersion > updateInfoResponse.installedVersion {
            return .requiredUpdateNeeded
        }

        guard let latestVersion = updateInfoResponse.lastVersionAvailable else {
            return .noUpdateAvailable
        }

        let shouldNotify = !latestVersion.wasNotified || updateInfoResponse.notificationType == .always

        if (latestVersion > updateInfoResponse.installedVersion) && shouldNotify {
            updateInfoResponse.lastVersionAvailable?.markNotified()
            return .newUpdateAvailable
        }

        return .noUpdateAvailable
    }

    public var versionInfo: UpdateInfo {
        return updateInfoResponse.versionInfo
    }

    /**
     Returns global metadata merged with metadata for configuration.
     */
    public var metadata: [String : Any]? {
        return updateInfoResponse.metadata
    }
}

//
//  NotificationType.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 28/05/2020.
//

import Foundation

// MARK: - Swift - Public notification type -

/**
 Returns update status notification frequency.

 Possible values are: `Once` and `Always`.

If `NotificationType` is **once**,  only first time when new app update is available, `updateStatus` will be `.newUpdateAvailable`, each subsequent call, `updateStatus` value is going to be `.noUpdateAvailable`.

 If `NotificationType` is **always**, `updateStatus` will always return `.newUpdateAvailable` if new optional app update is available.
 */
public enum NotificationType: String, Codable {
    case always = "ALWAYS"
    case once = "ONCE"

    enum CodingKeys: CodingKey {
        case always
        case once
    }
}

// MARK: - Objective-C Public notification type -

@objc
public enum UpdateNotificationType: Int {
    case once
    case always
}

// MARK: - Internal helpers -

internal extension NotificationType {

    var updateNotificationType: UpdateNotificationType {
        switch self {
        case .always: return .always
        case .once: return .once
        }
    }
}

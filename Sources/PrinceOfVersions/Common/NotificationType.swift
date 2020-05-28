//
//  NotificationType.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 28/05/2020.
//

import Foundation

// MARK: - Swift - Public notification type -

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

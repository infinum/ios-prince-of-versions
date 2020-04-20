////
////  UpdateInfoObjectiveC.swift
////  PrinceOfVersions
////
////  Created by Ivana Mršić on 17/04/2020.
////
//
//import Foundation
//
//@objcMembers
//class UpdateInfoObject: NSObject {
//
//    @objc public enum UpdateNotificationType: Int {
//        case once
//        case always
//    }
//
//    private let updateInfo: UpdateInfo
//
//    init(updateInfo: UpdateInfoData) {
//        self.updateInfo = updateInfo
//        self.notificationType = updateInfo.notificationType.updateNotificationType
//    }
//
//    // MARK: - Public properties
//
//    /**
//     Returns notification type.
//
//     Possible values are:
//     - Once: Show notification only once
//     - Always: Show notification every time app run
//
//     Default value is `.once`
//     */
//    @objc public private(set) var notificationType: UpdateNotificationType
//
//}
//
//extension UpdateInfoObject: UpdateInfo {
//
//    var requiredVersion: Version? {
//        return updateInfo.requiredVersion
//    }
//
//    var lastVersionAvailable: Version? {
//        return updateInfo.lastVersionAvailable
//    }
//
//    var installedVersion: Version {
//        return updateInfo.installedVersion
//    }
//
//    var requirements: [String : Any]? {
//        return updateInfo.requirements
//    }
//}
//
//// MARK: - Private helpers -
//
//private extension UpdateInfoData.NotificationType {
//
//    var updateNotificationType: UpdateInfoObject.UpdateNotificationType {
//        switch self {
//        case .always: return .always
//        case .once: return .once
//        }
//    }
//}

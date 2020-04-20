////
////  UpdateResultObjectiveC.swift
////  PrinceOfVersions
////
////  Created by Jasmin Abou Aldan on 13/09/2019.
////  Copyright © 2019 Infinum Ltd. All rights reserved.
////
//
//import Foundation
//
//@objcMembers
//public class UpdateResultObject: NSObject {
//
//    @objc public enum UpdateStatusType: Int {
//        case noUpdateAvailable
//        case requiredUpdateNeeded
//        case newUpdateAvailable
//    }
//
//    // MARK: - Private properties
//
//    private var updateInfo: UpdateInfoObject
//
//    // MARK: - Init
//    init(from updateInfo: UpdateInfoObject) {
//        self.updateInfo = updateInfo
//    }
//}
//
//// MARK: - Public wrappers -
//
//extension UpdateResultObject: UpdateResultData {
//
//    var updateVersion: Version {
//        return updateInfo.lastVersionAvailable ?? updateInfo.installedVersion
//    }
//
//    var updateState: UpdateStatus {
//        return .noUpdateAvailable
//    }
//
//    var versionInfo: UpdateInfo {
//        return updateInfo
//    }
//
//    var metadata: [String : Any]? {
//        return nil
//    }
//}
//
//// MARK: - Private helpers -
//
//private extension UpdateStatus {
//
//    var updateNotificationType: UpdateResultObject.UpdateStatusType {
//        switch self {
//        case .noUpdateAvailable: return .noUpdateAvailable
//        case .requiredUpdateNeeded: return .requiredUpdateNeeded
//        case .newUpdateAvailable: return .newUpdateAvailable
//        }
//    }
//}

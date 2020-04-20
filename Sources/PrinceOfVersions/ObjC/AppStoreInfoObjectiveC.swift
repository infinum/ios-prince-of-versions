////
////  UpdateInfoObjectiveC.swift
////  PrinceOfVersions
////
////  Created by Jasmin Abou Aldan on 13/09/2019.
////  Copyright © 2019 Infinum Ltd. All rights reserved.
////
//
//import Foundation
//
//@objcMembers
//public class AppStoreInfoObject: NSObject {
//
//    // MARK: - Private properties
//    private var appStoreInfo: AppStoreInfo
//
//    // MARK: - Init
//    init(from appStoreInfo: AppStoreInfo) {
//        self.appStoreInfo = appStoreInfo
//    }
//}
//
//// MARK: - Public wrappers -
//
//// Should be updated with new properties from UpdateInfo
//
//extension AppStoreInfoObject: UpdateInfoData {
//
//    /**
//     Returns latest available version of the app.
//     */
//    public var latestVersion: Version {
//        return appStoreInfo.latestVersion
//    }
//
//    /**
//     Returns sdk for latest available version of the app.
//     */
//    public var minimumSdkForLatestVersion: Version? {
//        return appStoreInfo.minimumSdkForLatestVersion
//    }
//
//    /**
//     Returns installed version of the app.
//     */
//    public var installedVersion: Version {
//        return appStoreInfo.installedVersion
//    }
//
//    /**
//     Returns sdk version of device.
//     */
//    public var sdkVersion: Version {
//        return appStoreInfo.sdkVersion
//    }
//}

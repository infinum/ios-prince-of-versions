//
//  AppStoreUpdateInfoObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 02/06/2020.
//

import Foundation

@objcMembers
public class AppStoreUpdateInfoObject: NSObject {

    // MARK: - Private properties
    private var appStoreInfo: AppStoreUpdateInfo

    // MARK: - Init
    internal init(from appStoreInfo: AppStoreUpdateInfo) {
        self.appStoreInfo = appStoreInfo
    }
}

// MARK: - Public properties -

extension AppStoreUpdateInfoObject {

    public var releaseDate: Date? {
        return appStoreInfo.releaseDate
    }
}

// MARK: - BaseUpdateInfo

extension AppStoreUpdateInfoObject: BaseUpdateInfo {

    /// Returns latest available version of the app.
    public var lastVersionAvailable: Version? {
        return appStoreInfo.lastVersionAvailable
    }

    /// Returns installed version of the app.
    public var installedVersion: Version {
        return appStoreInfo.installedVersion
    }
}

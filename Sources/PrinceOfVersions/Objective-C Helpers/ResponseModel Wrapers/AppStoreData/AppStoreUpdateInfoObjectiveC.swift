//
//  AppStoreUpdateInfoObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 02/06/2020.
//

import Foundation

@objc(AppStoreUpdateInfo)
@objcMembers
public class __ObjCAppStoreUpdateInfo: NSObject {

    // MARK: - Private properties

    private var appStoreInfo: AppStoreUpdateInfo

    // MARK: - Init

    internal init(from appStoreInfo: AppStoreUpdateInfo) {
        self.appStoreInfo = appStoreInfo
    }
}

// MARK: - Public properties -

extension __ObjCAppStoreUpdateInfo: BaseUpdateInfo {

    /// Returns latest available version of the app.
    public var lastVersionAvailable: Version? {
        return appStoreInfo.lastVersionAvailable
    }

    /// Returns installed version of the app.
    public var installedVersion: Version {
        return appStoreInfo.installedVersion
    }
}

extension __ObjCAppStoreUpdateInfo {

    /// Returns latest version release date.
    public var releaseDate: Date? {
        return appStoreInfo.releaseDate
    }
}

//
//  UpdateInfoObjectiveC.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//

import Foundation

@objcMembers
public class AppStoreInfoObject: NSObject {

    // MARK: - Private properties
    private var appStoreInfo: AppStoreInfo

    // MARK: - Init
    internal init(from appStoreInfo: AppStoreInfo) {
        self.appStoreInfo = appStoreInfo
    }
}

// MARK: - Public wrappers -

// Should be updated with new properties from UpdateInfo

extension AppStoreInfoObject: UpdateInfoValues {

    /**
     Returns minimum required version of the app.
     */
    public var requiredVersion: Version? {
        return appStoreInfo.requiredVersion
    }

    /**
     Returns latest available version of the app.
     */
    public var lastVersionAvailable: Version? {
        return appStoreInfo.lastVersionAvailable
    }

    /**
     Returns installed version of the app.
     */
    public var installedVersion: Version {
        return appStoreInfo.installedVersion
    }

    /**
     Returns requirements for configuration.
     */
    public var requirements: [String : Any]? {
        return appStoreInfo.requirements
    }
}

//
//  AppVersionChecker.swift
//  AppVersionChecker
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit

public class AppVersionChecker{

    private let BundleShortString = "CFBundleShortVersionString"
    private var URL: NSURL!
    var data: DataParser!

    /**
     Initializes connection with server that contains JSON information.

     - parameter compareWithDataFrom: Takes URL Address in String format
     */
    public init(takeDataFrom: String){
        URL = NSURL(string: takeDataFrom)
        data = DataParser(fromURL: URL)
    }

    /**
     Reload data from server.
     */
    public func loadConfiguration() {
        data.reloadData()
    }

    /**
     Return minimum required version of app

     -returns: String with minimum app version
     */
    public func getMinimumVersion() -> String? {
        guard data.minimumVersion != nil else {
            return nil
        }
        return data.minimumVersion
    }

    /**
     Return notification type. Possible values are:
     
     - ONCE: Show notification only once
     - ALWAYS: Show notification every time app run

     -returns: String once/always
     */
    public func getNotificationType() -> String? {
        guard data.notificationType != nil else {
            return nil
        }
        return data.notificationType
    }

    /**
     Return current available version of app

     -returns: String with current app version
     */
    public func getCurrentVersion() -> String? {
        guard data.version != nil else {
            return nil
        }
        return data.version
    }

    /**
     Return current installed version of app

     -returns: String with current installed version
     */
    public func getInstalledVersion() -> String? {
        guard var dict = NSBundle.mainBundle().infoDictionary else {
            return nil
        }
        let currentVersion = dict[BundleShortString] as! String
        return currentVersion
    }

    /**
     Checks and return true if minimum version requirement is satisfied

     -returns: true if it is satisfied, else returns false
     */
    public func isMinimumVersionSatisfied() -> Bool? {
        guard getMinimumVersion() != nil else {
            return nil
        }
        if getMinimumVersion() <= getInstalledVersion(){
            return true
        } else {
            return false
        }
    }
}
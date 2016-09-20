//
//  UpdateInfo.swift
//  Pods
//
//  Created by Jasmin Abou Aldan on 06/07/16.
//
//

import Foundation

public enum NotificationType : String {
    case always = "ALWAYS"
    case once = "ONCE"
}

public struct UpdateInfo {

    /**
     Return minimum required version of the app

     - returns: String with minimum app version
     */
    public fileprivate(set) var minimumRequiredVersion: String?

    /**
     Return notification type. Possible values are:

     - Once: Show notification only once
     - Always: Show notification every time app run

     - returns: NotificationType
     */
    public fileprivate(set) var notificationType: NotificationType?

    /**
     Return current available version of the app

     - returns: String with current app version
     */
    public fileprivate(set) var currentAvailableVersion: String?

    /**
     Return current installed version of the app

     - returns: String with current installed version
     */
    public var currentInstalledVersion: String? {
        guard var dict = Bundle.main.infoDictionary else {
            return nil
        }
        let currentVersion = dict["CFBundleShortVersionString"] as? String
        return currentVersion
    }

    /**
     Checks and return true if minimum version requirement is satisfied

     - returns: true if it is satisfied, else returns false
     */
    public var isMinimumVersionSatisfied: Bool? {
        if let minimum = minimumRequiredVersion, let current = currentInstalledVersion {
            if minimum <= current {
                return true
            } else {
                return false
            }
        } else {
            return nil
        }
    }

    internal init(data: Data) {

        var optionalUpdate: [String: AnyObject]
        let json = try? JSONSerialization.jsonObject(with:data, options: []) as? NSDictionary

        guard let value = json as? [String: AnyObject] else {
            return
        }

        guard let os = value["ios"] as? [String: AnyObject] else {
            return
        }

        if let minimumVersion = os["minimum_version"] as? String {
            self.minimumRequiredVersion = minimumVersion
        }

        if let optionalUpdateValues = os["optional_update"] as? [String: AnyObject] {
            optionalUpdate = optionalUpdateValues

            if let notTyp = optionalUpdate["notification_type"] as? NotificationType.RawValue {
                switch notTyp {
                case "ALWAYS":
                    self.notificationType = NotificationType.always
                default:
                    self.notificationType = NotificationType.once
                }
            }

            if let ver = optionalUpdate["version"] as? String {
                self.currentAvailableVersion = ver
            }
        }
    }
}

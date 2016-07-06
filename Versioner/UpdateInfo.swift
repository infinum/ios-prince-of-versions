//
//  UpdateInfo.swift
//  Pods
//
//  Created by Jasmin Abou Aldan on 06/07/16.
//
//

public enum NotificationType : String {
    case Always = "ALWAYS"
    case Once = "ONCE"
}

public struct UpdateInfo {

    /**
     Return minimum required version of the app

     - returns: String with minimum app version
     */
    public private(set) var minimumRequiredVersion: String?

    /**
     Return notification type. Possible values are:

     - Once: Show notification only once
     - Always: Show notification every time app run

     - returns: NotificationType
     */
    public private(set) var notificationType: NotificationType?

    /**
     Return current available version of the app

     - returns: String with current app version
     */
    public private(set) var currentAvailableVersion: String?


    public init(data: NSData) {

        var optionalUpdate: [String: AnyObject]
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary

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
                    self.notificationType = NotificationType.Always
                default:
                    self.notificationType = NotificationType.Once
                }
            }

            if let ver = optionalUpdate["version"] as? String {
                self.currentAvailableVersion = ver
            }
        }
    }

    /**
     Return current installed version of the app

     - returns: String with current installed version
     */
    public var currentInstalledVersion: String? {
        guard var dict = NSBundle.mainBundle().infoDictionary else {
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
        if minimumRequiredVersion == nil || currentInstalledVersion == nil {
            return nil
        } else {
            if minimumRequiredVersion <= currentInstalledVersion {
                return true
            } else {
                return false
            }
        }
    }

}



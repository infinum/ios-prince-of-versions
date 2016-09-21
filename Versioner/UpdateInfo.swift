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

public struct Version {
    public var major: Int
    public var minor: Int
    public var patch: Int
}

public struct UpdateInfo {

    /**
     Returns minimum required version of the app

     - returns: Version type of minimum app version
     */
    public private(set) var minimumRequiredVersion: Version?

    /**
     Returns notification type. Possible values are:

     - Once: Show notification only once
     - Always: Show notification every time app run

     - returns: NotificationType
     */
    public private(set) var notificationType: NotificationType?

    /**
     Returns latest available version of the app

     - returns: Version type with current available app version
     */
    public private(set) var latestVersion: Version?

    /**
     Returns installed version of the app

     - returns: Version with current installed version
     */
    public var installedVersion: Version? {
        guard var dict = Bundle.main.infoDictionary else {
            return nil
        }
        let currentVersion = dict["CFBundleShortVersionString"] as! String
        return _version(fromString: currentVersion)
    }

    /**
     Checks and return true if minimum version requirement is satisfied

     - returns: true if it is satisfied, else returns false
     */
    public var isMinimumVersionSatisfied: Bool? {
        guard let minimum = minimumRequiredVersion, let installed = installedVersion else {
            return nil
        }
        return _isVersionSatisfied(minimum: minimum, installed: installed)
    }

    /**
     Key-value pairs under "meta" key are optional metadata of which any amount can be sent accompanying the required fields
     
     - returns: Data in key-value [String: AnyObject] pairs
     */
    public private(set) var metadata: [String: AnyObject]?

    //MARK: - Private method for handling version
    private func _version(fromString string: String) -> Version {
        var stringToArray = string.components(separatedBy: ".")
        if !stringToArray.indices.contains(1) {
            stringToArray.append("0")
        }
        if !stringToArray.indices.contains(2) {
            stringToArray.append("0")
        }
        let arrayToIntegers = stringToArray.map{Int($0)!}
        return(Version.init(major: arrayToIntegers[0], minor: arrayToIntegers[1], patch: arrayToIntegers[2]))
    }

    private func _isVersionSatisfied(minimum: Version, installed: Version) -> Bool {
        if minimum.major < installed.major {
            return true
        } else if minimum.major == installed.major {
            if minimum.minor < installed.minor {
                return true
            } else if minimum.minor == installed.minor {
                if minimum.patch <= installed.patch {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
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
            self.minimumRequiredVersion = _version(fromString: minimumVersion)
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
                self.latestVersion = _version(fromString: ver)
            }
        }

        if let meta = value["meta"] as? [String: AnyObject] {
            metadata = meta
        } else {
            metadata = nil
        }

    }
}

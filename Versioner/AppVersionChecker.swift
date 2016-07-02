//
//  AppVersionChecker.swift
//  AppVersionChecker
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit

public enum NotificationType : String {
    case Always = "ALWAYS"
    case Once = "ONCE"
}

public struct UpdateInfo {

    /**
     Return minimum required version of app

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
     Return current available version of app

     - returns: String with current app version
     */
    public private(set) var currentAvailableVersion: String?

    
    public init(data: NSData){

        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary

        guard let value = json as? [String: AnyObject] else{
            return
        }

        guard let os = value["ios"] as? [String: AnyObject] else{
            return
        }

        if let minVer = os["minimum_version"] as? String{
            self.minimumRequiredVersion = minVer
        }

        guard let optionalUpdate = os["optional_update"] as? [String: AnyObject] else{
            return
        }

        if let notTyp = optionalUpdate["notification_type"] as? NotificationType.RawValue{
            switch notTyp {
            case "ALWAYS":
                self.notificationType = NotificationType.Always
            default:
                self.notificationType = NotificationType.Once
            }
        }

        if let ver = optionalUpdate["version"] as? String{
            self.currentAvailableVersion = ver
        }
    }

    /**
     Return current installed version of app

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
        guard minimumRequiredVersion != nil else {
            return nil
        }
        guard currentInstalledVersion != nil else {
            return nil
        }
        if minimumRequiredVersion <= currentInstalledVersion {
            return true
        } else {
            return false
        }
    }
}


public struct AppVersionChecker{
    public init(){}

    /**
     Check mimum required version, current installed version on device and current available version of app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user.
     
     - parameters:
        - configurationURL: URL that containts configuration data
        - completion:       The completion handler to call when the load request is complete. 

            This completion handler takes the following parameters:

            `data`
                            
            Parsed data returned by the server.
                            
            `error`
                            
            An error object that indicates why the request failed, or nil if the request was successful.

     - returns: Configuration data
     */
    public func loadCondiguration(configurationURL: NSURL, completion: (data: UpdateInfo?, error: NSError?) -> Void){

        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var dataTask: NSURLSessionDataTask?

        dataTask = defaultSession.dataTaskWithURL(configurationURL, completionHandler: {
            (data, response, error) in

            if error != nil{
                completion(data: nil, error: error)
                return
            }

            if let dic = data {
                let data = UpdateInfo(data: dic)
                completion(data: data, error: error)
            }
        })
        dataTask?.resume()
    }
}
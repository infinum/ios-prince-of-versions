//
//  Versioner.swift
//  Versioner
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit

public class Versioner{

    var stringURL: String!
    private var URL: NSURL!
    var data: DataValues!

    /**
     Initializes connection with server that contains JSON information.

     - parameter compareWithDataFrom: Takes URL Address in String format
     */
    public init(compareWithDataFrom: String){
        self.stringURL = compareWithDataFrom

        URL = NSURL(string: self.stringURL)
        data = DataValues(fromURL: URL)
    }

    /**
     Return minimum required version of app

     -returns: String with minimum app version
     */
    public func getMinimumVersion() -> String{
        return data.minimumVersion
    }

    /**
     Return notification type. Possible values are:
     
     - ONCE: Show notification only once
     - ALWAYS: Show notification every time app run

     -returns: String once/always
     */
    public func getNotificationType() -> String{
        return data.notificationType
    }

    /**
     Return current available version of app

     -returns: String with current app version
     */
    public func getCurrentVersion() -> String{
        return data.version
    }

    /**
     Return current installed version of app

     -returns: String with current installed version
     */
    public func getInstalledVersion() -> String{
        let dict = NSBundle.mainBundle().infoDictionary!
        let currentVersion = dict["CFBundleShortVersionString"] as! String
        return currentVersion
    }

}



















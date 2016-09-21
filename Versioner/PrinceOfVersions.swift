//
//  AppVersionChecker.swift
//  AppVersionChecker
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit

private let UserDefaultsVersionKey = "co.infinum.princeofversions.version-"

public struct PrinceOfVersions {
    public init(){}

    /**
     Check mimum required version, current installed version on device and current available version of the app with data stored on URL.
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
    public func loadConfiguration(from URL: URL, completion: @escaping (UpdateInfo?, NSError?) -> Void) {

        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask?

        dataTask = defaultSession.dataTask(with: URL, completionHandler: {
            (data, response, error) in

            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error as NSError?)
                }
                return
            }

            if let data = data {
                let data = UpdateInfo(data: data)
                DispatchQueue.main.async {
                    completion(data, error as NSError?)
                }
            }
        })

        dataTask?.resume()
    }

    public func checkForUpdates(from URL: URL, newUpdate: @escaping (Version?,Bool?,[String:AnyObject]?) -> Void, noUpdate: @escaping ([String:AnyObject]?) -> Void, error: @escaping (NSError?) -> Void) {
        loadConfiguration(from: URL, completion: { (data,dataError) in
            if dataError != nil {
                error(dataError)
                return
            }
            let userDefaultsFullkey = UserDefaultsVersionKey+"\(data?.latestVersion?.major).\(data?.latestVersion?.minor).\(data?.latestVersion?.patch)"
            if UserDefaults.standard.bool(forKey: userDefaultsFullkey) == false || data?.notificationType == .always {
                newUpdate(data?.latestVersion, data?.isMinimumVersionSatisfied, data?.metadata)
                UserDefaults.standard.set(true, forKey: userDefaultsFullkey)
            } else {
                noUpdate(data?.metadata)
            }
        })
    }

}

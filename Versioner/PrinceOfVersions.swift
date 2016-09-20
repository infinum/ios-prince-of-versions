//
//  AppVersionChecker.swift
//  AppVersionChecker
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit

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
    public func loadConfiguration(URL: URL, completion: @escaping (UpdateInfo?, NSError?) -> Void) {

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

}

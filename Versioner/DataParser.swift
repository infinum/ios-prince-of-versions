//
//  DataParser.swift
//  AppVersionChecker
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit

class DataParser{

    struct JSONConstants {
        static let osName = "ios"
        static let minimumVersion = "minimum_version"
        static let optionalVersion = "optional_update"
        static let notificationType = "notification_type"
        static let currentVersion = "version"
    }

    private var url: NSURL!
    var minimumVersion: String!
    var notificationType: String!
    var version: String!

    init(fromURL: NSURL){
        self.url = fromURL
        reloadData()
    }

    func reloadData(){

        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var dataTask: NSURLSessionDataTask?

        dataTask = defaultSession.dataTaskWithURL(url){
            data, response, error in

            if error != nil{
                return
            }

            let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary

            guard let value = json as? [String: AnyObject] else{
                return
            }

            guard let os = value[JSONConstants.osName] as? [String: AnyObject] else{
                return
            }
            self.minimumVersion = os[JSONConstants.minimumVersion] as! String

            guard let optionalUpdate = os[JSONConstants.optionalVersion] as? [String: AnyObject] else{
                return
            }
            self.notificationType = optionalUpdate[JSONConstants.notificationType] as! String
            self.version = optionalUpdate[JSONConstants.currentVersion] as! String
        }
        dataTask?.resume()
    }
}
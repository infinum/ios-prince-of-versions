//
//  DataValues.swift
//  Versioner
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit

class DataValues{

    struct JSONConstants {
        static let osName = "ios"
        static let minimumVersion = "minimum_version"
        static let optionalVersion = "optional_update"
        static let notificationType = "notification_type"
        static let currentVersion = "version"
    }

    private var url: NSURL!
    private var value: AnyObject!

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

            if let error = error{
                print("Error in fetching data from server with error: \(error.localizedDescription)")
                return
            }

            do{
                self.value = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            } catch {
                print("Error in parsing JSON")
            }

            guard let value = self.value as? [String: AnyObject] else{
                print("Error in reading JSON")
                return
            }

            guard let os = value[JSONConstants.osName] as? [String: AnyObject] else{
                //There is no "ios" key in JSON
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
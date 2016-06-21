//
//  DataValues.swift
//  Versioner
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit
import Alamofire

class DataValues{

    var minimumVersion: String!
    var notificationType: String!
    var version: String!

    init(fromURL: NSURL){

        Alamofire.request(.GET, fromURL).responseJSON { (response: Response<AnyObject, NSError>) in

            guard response.result.isSuccess else {
                print("Error in fetching data")
                return
            }

            guard let value = response.result.value as? [String: AnyObject] else{
                print("Error in JSON")
                return
            }

            let os = value["ios"]!
            let optionalUpdate = os["optional_update"]!!

            self.minimumVersion = os["minimum_version"] as! String
            self.notificationType = optionalUpdate["notification_type"] as! String
            self.version = optionalUpdate["version"] as! String

        }

    }
    
}
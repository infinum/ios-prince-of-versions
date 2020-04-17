//
//  ConfigurationData.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 16/04/2020.
//  Copyright © 2020 Infinum Ltd. All rights reserved.
//

import Foundation

enum JSONVersion {
    case v1
    case v2
}

protocol ConfigurationData {

    var version: JSONVersion { get }
    
    func validate() -> PrinceOfVersionsError?
}

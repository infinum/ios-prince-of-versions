//
//  Result.swift
//  PrinceOfVersions
//
//  Created by Vedran Burojevic on 19/05/2017.
//  Copyright © 2017 Infinum Ltd. All rights reserved.
//

import Foundation

public enum Result {
    case success(UpdateInfo)
    case failure(Error)
}

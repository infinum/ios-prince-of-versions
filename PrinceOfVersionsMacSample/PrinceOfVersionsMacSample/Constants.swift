//
//  Constants.swift
//  PrinceOfVersionsMacSample
//
//  Created by Jasmin Abou Aldan on 20/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

import Foundation

enum Constants {
    static let princeOfVersionsURL = "https://pastebin.com/raw/0MfYmWGu"
}

@objcMembers
class Constant: NSObject {

    private override init() {}

    static var princeOfVersionsURL: String {
        return Constants.princeOfVersionsURL
    }
}

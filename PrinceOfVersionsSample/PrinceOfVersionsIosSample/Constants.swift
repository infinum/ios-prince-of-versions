//
//  Constants.swift
//  PrinceOfVersionsSample
//
//  Created by Jasmin Abou Aldan on 14/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

import Foundation

enum Constants {
    static let princeOfVersionsURL = "https://pastebin.com/raw/LNVA8Gse"
}

@objcMembers class Constant: NSObject {

    private override init() {}

    static var princeOfVersionsURL: String {
        return Constants.princeOfVersionsURL
    }
}

//
//  UpdateInfoResponse.swift
//  PrinceOfVersions
//
//  Created by Vedran Burojevic on 19/05/2017.
//  Copyright © 2017 Infinum Ltd. All rights reserved.
//

import Foundation

public class UpdateInfoResponse: NSObject {
    /// The server's response to the URL request.
    @objc public let response: URLResponse?
    
    /// The result of response serialization.
    @objc public let result: Result
    
    /// Init
    init(response: URLResponse?, result: Result) {
        self.response = response
        self.result = result
    }
}

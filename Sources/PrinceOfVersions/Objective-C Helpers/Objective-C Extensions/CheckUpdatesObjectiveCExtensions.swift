//
//  CheckUpdatesObjectiveCExtensions.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 05/02/2020.
//  Copyright © 2020 Infinum Ltd. All rights reserved.
//

import Foundation

// MARK: - Check updates -

extension PrinceOfVersions {

    public typealias ObjectCompletionBlock = (UpdateResponse) -> Void
    public typealias ObjectErrorBlock = (NSError) -> Void

    /**
     Used for getting the versioning configuration stored on server. Uses URL for data fetch with posibility to set custom http headers, certificate pinning enabling and custom callback queue.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.

     - parameter URL: URL that containts configuration data.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdateResult data
     - parameter error: The completion handler to call when load request errors

     - returns: Discardable `URLSessionDataTask`
         */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:completion:error:)
    @discardableResult
    public func checkForUpdatesFromURL(_ URL: URL, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdates(from: URL, options: PoVOptions(), completion: completion, error: error)
    }
}

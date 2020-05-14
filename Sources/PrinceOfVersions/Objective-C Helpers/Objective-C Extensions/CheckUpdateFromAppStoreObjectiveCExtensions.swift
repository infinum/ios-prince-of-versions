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

    public typealias AppStoreObjectCompletionBlock = (AppStoreInfoObject) -> Void

    /**
     Used for getting the versioning information from the AppStore Connect.

     After check with server is finished, this method will return all informations about the app versioning available on AppStore Connect.
     It's up to the user to handle that info in a way sutable for the app.

     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data or PoVError error
     - parameter error: The completion handler to call when load request errors

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdateFromAppStoreWithCompletion:error:)
    @discardableResult
    public static func checkForUpdateFromAppStore(completion: @escaping AppStoreObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return internalyCheckAndPrepareForUpdateAppStore(completion: completion, error: error)
    }
}

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

     If flag `trackPhaseRelease` is set to `false`, the value of the `phaseReleaseInProgress` will instantly be `false` as phased release is not used.
     Otherwise, if we have to check `trackPhaseRelease`, value of `phaseReleaseInProgress` will return `false` once phased release period of 7 days is over.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), if `trackPhaseRelease` is enabled `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value set on AppStore Connect.

     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data or PrinceOfVersionsError error
     - parameter error: The completion handler to call when load request errors

     - returns: Discardable `URLSessionDataTask`
     */

    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdateFromAppStoreWithCompletion:error:)
    @discardableResult
    public func checkForUpdateFromAppStore(completion: @escaping AppStoreObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdateAppStore(completion: completion, error: error)
    }
}

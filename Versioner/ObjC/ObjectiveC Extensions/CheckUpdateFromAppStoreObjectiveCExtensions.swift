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

    public typealias AppStoreObjectCompletionBlock = (AppStoreResponse) -> Void

    /**
     Used for getting the versioning information from the AppStore Connect.

     After check with server is finished, this method will return all informations about the app versioning available on AppStore Connect.
     It's up to the user to handle that info in a way sutable for the app.

     If flag `trackPhaseRelease` is set to `false`, the value of the `phaseReleaseInProgress` will instantly be `false` as phased release is not used.
     Otherwise, if we have to check `trackPhaseRelease`, value of `phaseReleaseInProgress` will return `false` once phased release period of 7 days is over.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), if `trackPhaseRelease` is enabled `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value set on AppStore Connect.

     - parameter options: Options specifying how PoV should handle the request. Values available for configuring request are: HTTP header fields, certificate pinning enabled and callbackQueue. For details, see `PoVRequestOptions`
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data or PrinceOfVersionsError error
     - parameter error: The completion handler to call when load request errors

     - returns: Discardable `URLSessionDataTask`
     */

    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdateFromAppStoreWithOptions:completion:error:)
    @discardableResult
    public func checkForUpdateFromAppStore(options: PoVRequestOptions?, completion: @escaping AppStoreObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdateAppStore(
            trackPhaseRelease: options?.trackPhaseRelease ?? true,
            bundle: options?.bundle ?? .main,
            callbackQueue: options?.callbackQueue ?? .main,
            completion: completion,
            error: error
        )
    }
}

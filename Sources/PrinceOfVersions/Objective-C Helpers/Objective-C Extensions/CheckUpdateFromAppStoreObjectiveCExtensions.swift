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

     After check with server is finished, this method will return all informations about the app versioning available on the AppStore Connect.
     It's up to the user to handle that info in a way sutable for the app.

     Flag `trackPhaseRelese` will be set to `YES`.
     If flag `trackPhaseRelease` is set to `NO`, the value of the `phaseReleaseInProgress` will instantly be `NO` as phased release is not used.
     Otherwise, if we have to check `trackPhaseRelease`, value of `phaseReleaseInProgress` will return `NO` once phased release period of 7 days is over.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), if `trackPhaseRelease` is enabled `phaseReleaseInProgress` will return `NO` only after 7 days of `currentVersionReleaseDate` value set on AppStore Connect.

     - Parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data or PoVError error

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdateFromAppStoreWithCompletion:error:)
    @discardableResult
    public static func checkForUpdateFromAppStore(
        completion: @escaping AppStoreObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {
        return internalyCheckAndPrepareForUpdateAppStore(bundle: .main, trackPhaseRelease: true, callbackQueue: .main, completion: completion, error: error)
    }

    /**
     Used for getting the versioning information from the AppStore Connect.

     After check with server is finished, this method will return all informations about the app versioning available on AppStore Connect.
     It's up to the user to handle that info in a way sutable for the app.

     If flag `trackPhaseRelease` is set to `NO`, the value of the `phaseReleaseInProgress` will instantly be `NO` as phased release is not used.
     Otherwise, if we have to check `trackPhaseRelease`, value of `phaseReleaseInProgress` will return `NO` once phased release period of 7 days is over.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), if `trackPhaseRelease` is enabled `phaseReleaseInProgress` will return `NO` only after 7 days of `currentVersionReleaseDate` value set on AppStore Connect.

     - Parameters:
        * trackPhaseRelease: Boolean that indicates whether PoV should notify about new version after 7 days when app is fully rolled out or immediately. Default value is `YES`.
        * completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data or PoVError error

     - Returns:
        * Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdateFromAppStoreWithTrackPhasedRelease:completion:error:)
    @discardableResult
    public static func checkForUpdateFromAppStore(
        trackPhaseRelease: Bool,
        completion: @escaping AppStoreObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {
        return internalyCheckAndPrepareForUpdateAppStore(bundle: .main, trackPhaseRelease: trackPhaseRelease, callbackQueue: .main, completion: completion, error: error)
    }

    /**
     Used for getting the versioning information from the AppStore Connect.

     After check with server is finished, this method will return all informations about the app versioning available on AppStore Connect.
     It's up to the user to handle that info in a way sutable for the app.

     If flag `trackPhaseRelease` is set to `NO`, the value of the `phaseReleaseInProgress` will instantly be `NO` as phased release is not used.
     Otherwise, if we have to check `trackPhaseRelease`, value of `phaseReleaseInProgress` will return `NO` once phased release period of 7 days is over.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), if `trackPhaseRelease` is enabled `phaseReleaseInProgress` will return `NO` only after 7 days of `currentVersionReleaseDate` value set on AppStore Connect.

     - Parameters:
        * bundle: Bundle where .plist file is stored in which app identifier and app versions should be checked.
        * trackPhaseRelease: Boolean that indicates whether PoV should notify about new version after 7 days when app is fully rolled out or immediately. Default value is `YES`.
        * callbackQueue: The queue on which the completion handler is dispatched. By default, `main` queue is used.
        * completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data or PoVError error

     - Returns:
        * Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdateFromAppStoreWithTrackPhasedRelease:callbackQueue:bundle:completion:error:)
    @discardableResult
    public static func checkForUpdateFromAppStore(
        trackPhaseRelease: Bool,
        callbackQueue: DispatchQueue,
        bundle: Bundle,
        completion: @escaping AppStoreObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {
        return internalyCheckAndPrepareForUpdateAppStore(bundle: bundle, trackPhaseRelease: trackPhaseRelease, callbackQueue: callbackQueue, completion: completion, error: error)
    }
}

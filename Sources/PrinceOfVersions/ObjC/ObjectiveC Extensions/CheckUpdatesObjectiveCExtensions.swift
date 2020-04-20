////
////  CheckUpdatesObjectiveCExtensions.swift
////  PrinceOfVersions
////
////  Created by Jasmin Abou Aldan on 05/02/2020.
////  Copyright © 2020 Infinum Ltd. All rights reserved.
////
//
//import Foundation
//
//// MARK: - Check updates -
//
//extension PrinceOfVersions {
//
//    /**
//     Used for getting the automated information about update availability from URL. Can set custom http fields and activate certificates pinning.
//
//     This method checks mimum required version, current installed version on device and current available version of the app with data stored on URL.
//     It also checks if minimum version is satisfied and what should be frequency of notifying user. Data is returned on the `main` thread.
//
//     - parameter URL: URL that containts configuration data.
//     - parameter options: Options specifying how PoV should handle the request. Values available for configuring request are: HTTP header fields, certificate pinning enabled and callbackQueue. For details, see `PoVRequestOptions`
//     - parameter newVersion: The completion handler to call when the load request is complete in case if new version is available. It returns result that contains info about new optional or non-optional available version, as well as info if minimum version is satisfied
//     - parameter noNewVersion: The completion handler to call when the load request is complete in case if there is no new versions available. It returns result that contains if minimum version is satisfied.
//     - parameter error: The completion handler to call when load request errors.
//
//     - returns: Discardable `URLSessionDataTask`
//     */
//    @available(swift, obsoleted: 1.0)
//    @objc(checkForUpdatesFromURL:options:newVersion:noNewVersion:error:)
//    @discardableResult
//    public func checkForUpdatesFromURL(_ URL: URL, options: PoVRequestOptions?, newVersion: @escaping NewVersionBlock, noNewVersion: @escaping NoNewVersionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
//        return self.internalyCheckAndPrepareForUpdates(
//            from: URL,
//            httpHeaderFields: options?.httpHeaderFields,
//            shouldPinCertificates: options?.shouldPinCertificates ?? false,
//            callbackQueue: options?.callbackQueue ?? .main,
//            error: error
//        )
//    }
//}

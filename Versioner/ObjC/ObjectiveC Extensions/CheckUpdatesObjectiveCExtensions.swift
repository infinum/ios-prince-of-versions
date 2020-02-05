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

    // Server configuration Only

    /**
     Used for getting the automated information about update availability from URL. Use URL only.

     This method checks mimum required version, current installed version on device and current available version of the app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user. Data is returned on the `main` thread.

     - parameter URL: URL that containts configuration data.
     - parameter newVersion: The completion handler to call when the load request is complete in case if new version is available. It returns result that contains info about new optional or non-optional available version, as well as info if minimum version is satisfied
     - parameter noNewVersion: The completion handler to call when the load request is complete in case if there is no new versions available. It returns result that contains if minimum version is satisfied.

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:newVersion:noNewVersion:error:)
    @discardableResult
    public func checkForUpdatesFromURL(_ URL: URL, newVersion: @escaping NewVersionBlock, noNewVersion: @escaping NoNewVersionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdates(
            from: URL,
            httpHeaderFields: nil,
            shouldPinCertificates: false,
            newVersion: newVersion,
            noNewVersion: noNewVersion,
            error: error
        )
    }

    // URL and headers

    /**
     Used for getting the automated information about update availability from URL. Can set custom http fields.

     This method checks mimum required version, current installed version on device and current available version of the app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user. Data is returned on the `main` thread.

     - parameter URL: URL that containts configuration data.
     - parameter httpHeaderFields: Optional HTTP header fields.
     - parameter shouldPinCertificates: Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
     - parameter newVersion: The completion handler to call when the load request is complete in case if new version is available. It returns result that contains info about new optional or non-optional available version, as well as info if minimum version is satisfied
     - parameter noNewVersion: The completion handler to call when the load request is complete in case if there is no new versions available. It returns result that contains if minimum version is satisfied.

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:httpHeaderFields:newVersion:noNewVersion:error:)
    @discardableResult
    public func checkForUpdatesFromURL(_ URL: URL, httpHeaderFields: NSDictionary?, newVersion: @escaping NewVersionBlock, noNewVersion: @escaping NoNewVersionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdates(
            from: URL,
            httpHeaderFields: httpHeaderFields,
            shouldPinCertificates: false,
            newVersion: newVersion,
            noNewVersion: noNewVersion,
            error: error
        )
    }

    // URL and certificates pinning

    /**
     Used for getting the automated information about update availability from URL. Can activate certificates pinning.

     This method checks mimum required version, current installed version on device and current available version of the app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user. Data is returned on the `main` thread.

     - parameter URL: URL that containts configuration data.
     - parameter httpHeaderFields: Optional HTTP header fields.
     - parameter shouldPinCertificates: Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
     - parameter newVersion: The completion handler to call when the load request is complete in case if new version is available. It returns result that contains info about new optional or non-optional available version, as well as info if minimum version is satisfied
     - parameter noNewVersion: The completion handler to call when the load request is complete in case if there is no new versions available. It returns result that contains if minimum version is satisfied.

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:shouldPinCertificates:newVersion:noNewVersion:error:)
    @discardableResult
    public func checkForUpdatesFromURL(_ URL: URL, shouldPinCertificates: Bool, newVersion: @escaping NewVersionBlock, noNewVersion: @escaping NoNewVersionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdates(
            from: URL,
            httpHeaderFields: nil,
            shouldPinCertificates: shouldPinCertificates,
            newVersion: newVersion,
            noNewVersion: noNewVersion,
            error: error
        )
    }

    // URL with callback Queue option

    /**
     Used for getting the automated information about update availability from URL. Can set custom http fields and activate certificates pinning.

     This method checks mimum required version, current installed version on device and current available version of the app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user.

     - parameter URL: URL that containts configuration data.
     - parameter callbackQueue: An operation queue for scheduling the completion handlers. If `backgrodun` is selected, callback will be called on the default serial queue. By default, `main` queue is used.
     - parameter newVersion: The completion handler to call when the load request is complete in case if new version is available. It returns result that contains info about new optional or non-optional available version, as well as info if minimum version is satisfied
     - parameter noNewVersion: The completion handler to call when the load request is complete in case if there is no new versions available. It returns result that contains if minimum version is satisfied.

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:callbackQueue:newVersion:noNewVersion:error:)
    @discardableResult
    public func checkForUpdatesFromURL(_ URL: URL, callbackQueue: CallbackQueue, newVersion: @escaping NewVersionBlock, noNewVersion: @escaping NoNewVersionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdates(
            from: URL,
            httpHeaderFields: nil,
            shouldPinCertificates: false,
            callbackQueue: callbackQueue,
            newVersion: newVersion,
            noNewVersion: noNewVersion,
            error: error
        )
    }

    // All options

    /**
     Used for getting the automated information about update availability from URL. Can set custom http fields and activate certificates pinning.

     This method checks mimum required version, current installed version on device and current available version of the app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user. Data is returned on the `main` thread.

     - parameter URL: URL that containts configuration data.
     - parameter httpHeaderFields: Optional HTTP header fields.
     - parameter shouldPinCertificates: Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
     - parameter callbackQueue: An operation queue for scheduling the completion handlers. If `backgrodun` is selected, callback will be called on the default serial queue. By default, `main` queue is used.
     - parameter newVersion: The completion handler to call when the load request is complete in case if new version is available. It returns result that contains info about new optional or non-optional available version, as well as info if minimum version is satisfied
     - parameter noNewVersion: The completion handler to call when the load request is complete in case if there is no new versions available. It returns result that contains if minimum version is satisfied.

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:httpHeaderFields:shouldPinCertificates:callbackQueue:newVersion:noNewVersion:error:)
    @discardableResult
    public func checkForUpdatesFromURL(_ URL: URL, httpHeaderFields: NSDictionary?, shouldPinCertificates: Bool, callbackQueue: CallbackQueue, newVersion: @escaping NewVersionBlock, noNewVersion: @escaping NoNewVersionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdates(
            from: URL,
            httpHeaderFields: httpHeaderFields,
            shouldPinCertificates: shouldPinCertificates,
            callbackQueue: callbackQueue,
            newVersion: newVersion,
            noNewVersion: noNewVersion,
            error: error
        )
    }
}

//
//  LoadConfigurationObjectiveCExtensions.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 05/02/2020.
//  Copyright © 2020 Infinum Ltd. All rights reserved.
//

import Foundation

// MARK: - Load Configuration -

extension PrinceOfVersions {

    // MARK: - Public interface

    public typealias ObjectCompletionBlock = (UpdateResponse) -> Void
    public typealias ObjectErrorBlock = (NSError) -> Void

    // URL only

    /**
     Used for getting the versioning configuration stored on server. Use only URL.

     After check with server is finished, this method will return all informations about the app versioning, by default on `main` thread.
     It's up to the user to handle that info in a way sutable for the app.
     For automated check if new optional or mandatory version is available, you can use `checkForUpdates` method.

     - parameter URL: URL that containts configuration data.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data
     - parameter error: The completion handler to call when load request errors. It returns UpdateInfoError error

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(loadConfigurationFromURL:completion:error:)
    @discardableResult
    public func loadConfigurationFromURL(_ URL: URL, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyLoadAndPrepareConfiguration(
            from: URL,
            httpHeaderFields: nil,
            shouldPinCertificates: false,
            completion: completion,
            error: error
        )
    }

    // URL with custom http header fields

    /**
     Used for getting the versioning configuration stored on server. Can set custom http header fields.

     After check with server is finished, this method will return all informations about the app versioning, by default on `main` thread.
     It's up to the user to handle that info in a way sutable for the app.
     For automated check if new optional or mandatory version is available, you can use `checkForUpdates` method.

     - parameter URL: URL that containts configuration data.
     - parameter httpHeaderFields: Optional HTTP header fields.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data
     - parameter error: The completion handler to call when load request errors. It returns UpdateInfoError error

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(loadConfigurationFromURL:httpHeaderFields:completion:error:)
    @discardableResult
    public func loadConfigurationFromURL(_ URL: URL, httpHeaderFields: NSDictionary?, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {
        return self.internalyLoadAndPrepareConfiguration(
            from: URL,
            httpHeaderFields: httpHeaderFields,
            shouldPinCertificates: false,
            completion: completion,
            error: error
        )
    }

    // URL with only pinning option

    /**
     Used for getting the versioning configuration stored on server. Can activate certificate pinning.

     After check with server is finished, this method will return all informations about the app versioning, by default on `main` thread.
     It's up to the user to handle that info in a way sutable for the app.
     For automated check if new optional or mandatory version is available, you can use `checkForUpdates` method.

     - parameter URL: URL that containts configuration data.
     - parameter shouldPinCertificates: Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data
     - parameter error: The completion handler to call when load request errors. It returns UpdateInfoError error

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(loadConfigurationFromURL:shouldPinCertificates:completion:error:)
    @discardableResult
    public func loadConfigurationFromURL(_ URL: URL, shouldPinCertificates: Bool, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyLoadAndPrepareConfiguration(
            from: URL,
            httpHeaderFields: nil,
            shouldPinCertificates: shouldPinCertificates,
            completion: completion,
            error: error
        )
    }

    // URL with callback Queue option

    /**
     Used for getting the versioning configuration stored on server. Can set different delegate queue.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.
     For automated check if new optional or mandatory version is available, you can use `checkForUpdates` method.

     - parameter URL: URL that containts configuration data.
     - parameter callbackQueue: An operation queue for scheduling the completion handlers. If `backgrodun` is selected, callback will be called on the default serial queue. By default, `main` queue is used.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data
     - parameter error: The completion handler to call when load request errors. It returns UpdateInfoError error

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(loadConfigurationFromURL:callbackQueue:completion:error:)
    @discardableResult
    public func loadConfigurationFromURL(_ URL: URL, callbackQueue: CallbackQueue, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyLoadAndPrepareConfiguration(
            from: URL,
            httpHeaderFields: nil,
            shouldPinCertificates: false,
            callbackQueue: callbackQueue,
            completion: completion,
            error: error
        )
    }

    // All options

    /**
     Used for getting the versioning configuration stored on server. Uses URL for data fetch with posibility to set custom http headers, certificate pinning enabling and custom callback queue.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.
     For automated check if new optional or mandatory version is available, you can use `checkForUpdates` method.

     - parameter URL: URL that containts configuration data.
     - parameter httpHeaderFields: Optional HTTP header fields.
     - parameter shouldPinCertificates: Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
     - parameter callbackQueue: An operation queue for scheduling the completion handlers. If `backgrodun` is selected, callback will be called on the default serial queue. By default, `main` queue is used.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data
     - parameter error: The completion handler to call when load request errors. It returns UpdateInfoError error

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(loadConfigurationFromURL:httpHeaderFields:shouldPinCertificates:callbackQueue:completion:error:)
    @discardableResult
    public func loadConfigurationFromURL(_ URL: URL, httpHeaderFields: NSDictionary?, shouldPinCertificates: Bool, callbackQueue: CallbackQueue, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyLoadAndPrepareConfiguration(
            from: URL,
            httpHeaderFields: httpHeaderFields,
            shouldPinCertificates: shouldPinCertificates,
            callbackQueue: callbackQueue,
            completion: completion,
            error: error
        )
    }
}

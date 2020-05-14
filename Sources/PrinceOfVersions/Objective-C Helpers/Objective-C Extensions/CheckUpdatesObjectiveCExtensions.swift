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

     - Parameters:
        * URL: URL that containts configuration data.
        * completion: The completion handler to call when the load request is complete. It returns result that contains UpdateResult data
        * error: The completion handler to call when load request errors

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:completion:error:)
    @discardableResult
    public static func checkForUpdatesFromURL(_ URL: URL, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return internalyLoadAndPrepareConfiguration(from: URL, callbackQueue: .main, options: PoVRequestOptions(), completion: completion, error: error)
    }

    /**
     Used for getting the versioning configuration stored on server. Uses URL for data fetch with posibility to set custom http headers, certificate pinning enabling and custom callback queue.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.

     - Parameters:
        * URL: URL that containts configuration data.
        * options: TODO
        * completion: The completion handler to call when the load request is complete. It returns result that contains UpdateResult data
        * error: The completion handler to call when load request errors

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:options:completion:error:)
    @discardableResult
    public static func checkForUpdatesFromURL(_ URL: URL, options: PoVRequestOptions, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return internalyLoadAndPrepareConfiguration(from: URL, callbackQueue: .main, options: options, completion: completion, error: error)
    }

    /**
     Used for getting the versioning configuration stored on server. Uses URL for data fetch with posibility to set custom http headers, certificate pinning enabling and custom callback queue.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.

     - Parameters:
        * URL: URL that containts configuration data.
        * callbackQueue: The queue on which the completion handler is dispatched. By default, `main` queue is used.
        * completion: The completion handler to call when the load request is complete. It returns result that contains UpdateResult data
        * error: The completion handler to call when load request errors

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:callbackQueue:completion:error:)
    @discardableResult
    public static func checkForUpdatesFromURL(_ URL: URL, callbackQueue: DispatchQueue, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return internalyLoadAndPrepareConfiguration(from: URL, callbackQueue: callbackQueue, options: PoVRequestOptions(), completion: completion, error: error)
    }

    /**
     Used for getting the versioning configuration stored on server. Uses URL for data fetch with posibility to set custom http headers, certificate pinning enabling and custom callback queue.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.

     - Parameters:
        * URL: URL that containts configuration data.
        * callbackQueue: The queue on which the completion handler is dispatched. By default, `main` queue is used.
        * options: TODO
        * completion: The completion handler to call when the load request is complete. It returns result that contains UpdateResult data
        * error: The completion handler to call when load request errors

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:callbackQueue:options:completion:error:)
    @discardableResult
    public static func checkForUpdatesFromURL(_ URL: URL, callbackQueue: DispatchQueue, options: PoVRequestOptions, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return internalyLoadAndPrepareConfiguration(from: URL, callbackQueue: callbackQueue, options: options, completion: completion, error: error)
    }
}

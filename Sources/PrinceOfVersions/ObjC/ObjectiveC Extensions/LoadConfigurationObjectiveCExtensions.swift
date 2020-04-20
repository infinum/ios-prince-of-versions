////
////  LoadConfigurationObjectiveCExtensions.swift
////  PrinceOfVersions
////
////  Created by Jasmin Abou Aldan on 05/02/2020.
////  Copyright © 2020 Infinum Ltd. All rights reserved.
////
//
//import Foundation
//
//// MARK: - Load Configuration -
//
//extension PrinceOfVersions {
//
//    public typealias ObjectCompletionBlock = (UpdateResponse) -> Void
//    public typealias ObjectErrorBlock = (NSError) -> Void
//
//    /**
//     Used for getting the versioning configuration stored on server. Uses URL for data fetch with posibility to set custom http headers, certificate pinning enabling and custom callback queue.
//
//     After check with server is finished, this method will return all informations about the app versioning.
//     It's up to the user to handle that info in a way sutable for the app.
//     For automated check if new optional or mandatory version is available, you can use `checkForUpdates` method.
//
//     - parameter URL: URL that containts configuration data.
//     - parameter options: Options specifying how PoV should handle the request. Values available for configuring request are: HTTP header fields, certificate pinning enabled and callbackQueue. For details, see `PoVRequestOptions`
//     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data
//     - parameter error: The completion handler to call when load request errors
//
//     - returns: Discardable `URLSessionDataTask`
//     */
//    @available(swift, obsoleted: 1.0)
//    @objc(loadConfigurationFromURL:options:completion:error:)
//    @discardableResult
//    public func loadConfigurationFromURL(_ URL: URL, options: PoVRequestOptions?, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
//        return self.internalyLoadAndPrepareConfiguration(
//            from: URL,
//            httpHeaderFields: options?.httpHeaderFields,
//            shouldPinCertificates: options?.shouldPinCertificates ?? false,
//            callbackQueue: options?.callbackQueue ?? .main,
//            completion: completion,
//            error: error
//        )
//    }
//}

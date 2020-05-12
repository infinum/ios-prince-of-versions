//
//  PoVObjC.swift
//  PrinceOfVersions
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 Infinum Ltd. All rights reserved.
//
// Used for exposing Swift methods to the ObjectiveC
// As we don't want to show duplicated methods (one for Swift and one for ObjC)
// simple @available will be used for hiding wrapper methods in Swift.

import Foundation

@objcMembers
public class UpdateResponse: NSObject {

    /// The server's response to the URL request.
    public let response: URLResponse?

    /// The result of response serialization.
    public let result: UpdateResultObject

    public init(response: URLResponse?, result: UpdateResultObject) {
        self.response = response
        self.result = result
    }
}

/**
 Used for configuring PoV request.
 By default, PoV will not use http header fields and certificate pinning. All callbacks (success/versions, failure) will be returned on the main queue.
 */
@objcMembers
public class PoVRequestOptions: NSObject {
    /// Optional HTTP header fields.
    public var httpHeaderFields: NSDictionary?
    /// Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
    public var shouldPinCertificates: Bool = false
    /// The queue on which the completion handler is dispatched. By default, `main` queue is used.
    public var callbackQueue: DispatchQueue = .main
    /// Boolean that indicates whether PoV should notify about new version after 7 days when app is fully rolled out or immediately. Default value is `true`.
    public var trackPhaseRelease: Bool = true
    /// Bundle where .plist file is stored in which app identifier and app versions should be checked.
    public var bundle: Bundle = .main
}

// MARK: Helpers

internal extension PrinceOfVersions {

    // MARK: Check updates

    func internalyLoadAndPrepareConfiguration(
        from URL: URL,
        options: PoVOptions,
        completion: @escaping ObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {

        if let headersError = checkHeadersValidity(from: options.httpHeaderFields) {
            error(headersError)
            return nil
        }

        return checkForUpdates(from: URL, options: options, completion: { response in
                switch response.result {
                case .success(let updateResult):
                    let updateResultResponse = UpdateResponse(
                        response: response.response,
                        result: UpdateResultObject(from: updateResult)
                    )
                    completion(updateResultResponse)
                case .failure(let (errorResponse as NSError)):
                    error(errorResponse)
                }
        })
    }

    // MARK: AppStore check

    func internalyCheckAndPrepareForUpdateAppStore(
        completion: @escaping AppStoreObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {
        return checkForUpdateFromAppStore(completion: { result in
                switch result {
                case .success(let appStoreInfo):
                    completion(AppStoreInfoObject(from: appStoreInfo))
                case .failure(let (errorResponse as NSError)):
                    error(errorResponse)
                }
        })
    }

    func checkHeadersValidity(from headers: NSDictionary?) -> NSError? {
        if headers == nil || (headers as? [String : String?]) != nil { return nil }
        return (PoVError.unknown("httpHeaderFields value should be in @{NSString : NSString} format.") as NSError)
    }
}

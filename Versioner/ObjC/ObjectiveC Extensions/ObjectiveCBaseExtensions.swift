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
    public let result: UpdateInfoObject

    public init(response: URLResponse?, result: UpdateInfoObject) {
        self.response = response
        self.result = result
    }
}

@objcMembers
public class AppStoreResponse: NSObject {

    /// The result of response serialization.
    public let result: AppStoreInfoObject

    public init(result: AppStoreInfoObject) {
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

    // MARK: Load configuration

    func internalyLoadAndPrepareConfiguration(
        from URL: URL,
        httpHeaderFields: NSDictionary?,
        shouldPinCertificates: Bool,
        callbackQueue: DispatchQueue = .main,
        completion: @escaping ObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {

        var headers: [String : String?]?
        do {
            headers = try checkHeadersValidity(from: httpHeaderFields).get()
        } catch let (headersError as NSError) {
            error(headersError)
            return nil
        }

        return self.loadConfiguration(
            from: URL,
            httpHeaderFields: headers,
            shouldPinCertificates: shouldPinCertificates,
            callbackQueue: callbackQueue,
            completion: { response in
                switch response.result {
                case .success(let updateInfo):
                    let updateInfoResponse = UpdateResponse(
                        response: response.response,
                        result: UpdateInfoObject(from: updateInfo)
                    )
                    completion(updateInfoResponse)
                case .failure(let (errorResponse as NSError)):
                    error(errorResponse)
                }
        })
    }

    // MARK: Check updates

    func internalyCheckAndPrepareForUpdates(
        from URL: URL,
        httpHeaderFields: NSDictionary?,
        shouldPinCertificates: Bool,
        callbackQueue: DispatchQueue = .main,
        newVersion: @escaping NewVersionBlock,
        noNewVersion: @escaping NoNewVersionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {

        var headers: [String : String?]?
        do {
            headers = try checkHeadersValidity(from: httpHeaderFields).get()
        } catch let (headersError as NSError) {
            error(headersError)
            return nil
        }

        return self.checkForUpdates(
            from: URL,
            httpHeaderFields: headers,
            shouldPinCertificates: shouldPinCertificates,
            callbackQueue: callbackQueue,
            newVersion: newVersion,
            noNewVersion: noNewVersion,
            error: { (checkError) in
                error((checkError as NSError))
        })
    }

    // MARK: AppStore check

    func internalyCheckAndPrepareForUpdateAppStore(
        trackPhaseRelease: Bool = true,
        bundle: Bundle = .main,
        callbackQueue: DispatchQueue = .main,
        completion: @escaping AppStoreObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {
        return self.checkForUpdateFromAppStore(
            trackPhaseRelease: trackPhaseRelease,
            bundle: bundle,
            callbackQueue: callbackQueue, completion: { response in
                switch response.result {
                case .success(let appStoreInfo):
                    let appStoreInfoResponse = AppStoreResponse(
                        result: AppStoreInfoObject(from: appStoreInfo)
                    )
                    completion(appStoreInfoResponse)
                case .failure(let (errorResponse as NSError)):
                    error(errorResponse)
                }
        })
    }

    func checkHeadersValidity(from headers: NSDictionary?) -> Result<[String: String?]?, NSError> {

        if headers == nil { return .success(nil) }

        if let httpHeaderFields = headers as? [String : String?] {
            return .success(httpHeaderFields)
        }

        return .failure((PrinceOfVersionsError.unknown("httpHeaderFields value should be in @{NSString : NSString} format.") as NSError))
    }
}
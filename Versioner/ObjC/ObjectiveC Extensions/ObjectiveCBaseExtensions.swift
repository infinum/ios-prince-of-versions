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

// MARK: Helpers

internal extension PrinceOfVersions {

    // MARK: Load configuration

    func internalyLoadAndPrepareConfiguration(
        from URL: URL,
        httpHeaderFields: NSDictionary?,
        shouldPinCertificates: Bool,
        callbackQueue: CallbackQueue = .main,
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
        callbackQueue: CallbackQueue = .main,
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

    func checkHeadersValidity(from headers: NSDictionary?) -> Result<[String: String?]?, NSError> {

        if headers == nil { return .success(nil) }

        if let httpHeaderFields = headers as? [String : String?] {
            return .success(httpHeaderFields)
        }

        return .failure((UpdateInfoError.unknown("httpHeaderFields value should be in @{NSString : NSString} format.") as NSError))
    }
}

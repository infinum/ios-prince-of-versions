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

// MARK: Helpers

internal extension PrinceOfVersions {

    // MARK: Check updates

    func internalyCheckAndPrepareForUpdates(
        from URL: URL,
        completion: @escaping ObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {

        if let headersError = checkHeadersValidity(from: options.httpHeaderFields) {
            error(headersError)
            return nil
        }

        return checkForUpdates(from: URL, completion: { response in
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

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

@objc(UpdateResponse)
@objcMembers
public class __ObjCUpdateResponse: NSObject {

    /// The server's response to the URL request.
    public let response: URLResponse?

    /// The result of response serialization.
    public let result: __ObjCUpdateResult

    public init(response: URLResponse?, result: __ObjCUpdateResult) {
        self.response = response
        self.result = result
    }
}

// MARK: Helpers

internal extension PrinceOfVersions {

    // MARK: Check updates

    static func internalyLoadAndPrepareConfiguration(
        from URL: URL,
        callbackQueue: DispatchQueue,
        options: PoVRequestOptions,
        completion: @escaping ObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {
        return PrinceOfVersions.checkForUpdates(from: URL, callbackQueue: callbackQueue, options: options, completion: { response in
                switch response.result {
                case .success(let updateResult):
                    let updateResultResponse = __ObjCUpdateResponse(
                        response: response.response,
                        result: __ObjCUpdateResult(from: updateResult)
                    )
                    completion(updateResultResponse)
                case .failure(let (errorResponse as NSError)):
                    error(errorResponse)
                }
        })
    }

    // MARK: AppStore check

    static func internalyCheckAndPrepareForUpdateAppStore(
        bundle: Bundle,
        trackPhaseRelease: Bool,
        callbackQueue: DispatchQueue,
        notificationFrequency: NotificationType = .always,
        completion: @escaping AppStoreObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
    ) -> URLSessionDataTask? {
        return PrinceOfVersions.checkForUpdateFromAppStore(trackPhaseRelease: trackPhaseRelease, bundle: bundle, callbackQueue: callbackQueue, notificationFrequency: notificationFrequency, completion: { result in
                switch result {
                case .success(let appStoreInfo):
                    completion(__ObjCAppStoreResult(from: appStoreInfo))
                case .failure(let (errorResponse as NSError)):
                    error(errorResponse)
                }
        })
    }
}

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

// MARK: - Load Configuration

extension PrinceOfVersions {

    // MARK: - Public interface

    public typealias ObjectCompletionBlock = (UpdateResponse) -> Void
    public typealias ObjectErrorBlock = (NSError) -> Void

    // URL only

    /**
     Used for getting the versioning configuration stored on server. Use only URL.

     After check with server is finished, this method will return all informations about the app versioning.
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
            delegateQueue: nil,
            completion: completion,
            error: error
        )
    }

    // URL with custom http header fields

    /**
     Used for getting the versioning configuration stored on server. Can set custom http header fields.

     After check with server is finished, this method will return all informations about the app versioning.
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
    public func loadConfigurationFromURL(_ URL: URL,
        httpHeaderFields: NSDictionary?,
        completion: @escaping ObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
        ) -> URLSessionDataTask? {
        return self.internalyLoadAndPrepareConfiguration(
            from: URL,
            httpHeaderFields: httpHeaderFields,
            shouldPinCertificates: false,
            delegateQueue: nil,
            completion: completion,
            error: error
        )
    }

    // URL with only pinning option

    /**
     Used for getting the versioning configuration stored on server. Can activate certificate pinning.

     After check with server is finished, this method will return all informations about the app versioning.
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
    public func loadConfigurationFromURL(
        _ URL: URL,
        shouldPinCertificates: Bool,
        completion: @escaping ObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
        ) -> URLSessionDataTask? {
        return self.internalyLoadAndPrepareConfiguration(
            from: URL,
            httpHeaderFields: nil,
            shouldPinCertificates: shouldPinCertificates,
            delegateQueue: nil,
            completion: completion,
            error: error
        )
    }

    // URL with delegate Queue option

    /**
     Used for getting the versioning configuration stored on server. Can set different delegate queue.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.
     For automated check if new optional or mandatory version is available, you can use `checkForUpdates` method.

     - parameter URL: URL that containts configuration data.
     - parameter delegateQueue: An operation queue for scheduling the delegate calls and completion handlers. The queue should be a serial queue, in order to ensure the correct ordering of callbacks. If nil, the session creates a serial operation queue for performing all delegate method calls and completion handler calls.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data
     - parameter error: The completion handler to call when load request errors. It returns UpdateInfoError error

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(loadConfigurationFromURL:delegateQueue:completion:error:)
    @discardableResult
    public func loadConfigurationFromURL(_ URL: URL, delegateQueue: OperationQueue?, completion: @escaping ObjectCompletionBlock, error: @escaping ObjectErrorBlock) -> URLSessionDataTask? {
        return self.internalyLoadAndPrepareConfiguration(
            from: URL,
            httpHeaderFields: nil,
            shouldPinCertificates: false,
            delegateQueue: delegateQueue,
            completion: completion,
            error: error
        )
    }

    // All options

    /**
     Used for getting the versioning configuration stored on server. Uses URL for data fetch with posibility to set custom http headers, certificate pinning enabling and custom delegate queue.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.
     For automated check if new optional or mandatory version is available, you can use `checkForUpdates` method.

     - parameter URL: URL that containts configuration data.
     - parameter httpHeaderFields: Optional HTTP header fields.
     - parameter shouldPinCertificates: Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
     - parameter delegateQueue: An operation queue for scheduling the delegate calls and completion handlers. The queue should be a serial queue, in order to ensure the correct ordering of callbacks. If nil, the session creates a serial operation queue for performing all delegate method calls and completion handler calls.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data
     - parameter error: The completion handler to call when load request errors. It returns UpdateInfoError error

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(loadConfigurationFromURL:httpHeaderFields:shouldPinCertificates:delegateQueue:completion:error:)
    @discardableResult
    public func loadConfigurationFromURL(
        _ URL: URL,
        httpHeaderFields: NSDictionary?,
        shouldPinCertificates: Bool,
        delegateQueue: OperationQueue?,
        completion: @escaping ObjectCompletionBlock,
        error: @escaping ObjectErrorBlock
        ) -> URLSessionDataTask? {
        return self.internalyLoadAndPrepareConfiguration(
            from: URL,
            httpHeaderFields: httpHeaderFields,
            shouldPinCertificates: shouldPinCertificates,
            delegateQueue: delegateQueue,
            completion: completion,
            error: error
        )
    }
}

// MARK: - Check updates

extension PrinceOfVersions {

    // URL Only

    /**
     Used for getting the automated information about update availability from URL. Use URL only.

     This method checks mimum required version, current installed version on device and current available version of the app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user.

     - parameter URL: URL that containts configuration data.
     - parameter newVersion: The completion handler to call when the load request is complete in case if new version is available. It returns result that contains info about new optional or non-optional available version, as well as info if minimum version is satisfied
     - parameter noNewVersion: The completion handler to call when the load request is complete in case if there is no new versions available. It returns result that contains if minimum version is satisfied.

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:newVersion:noNewVersion:error:)
    @discardableResult
    public func checkForUpdatesFromURL(
        _ URL: URL,
        newVersion: @escaping NewVersionBlock,
        noNewVersion: @escaping NoNewVersionBlock,
        error: @escaping ObjectErrorBlock
        ) -> URLSessionDataTask? {
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
     It also checks if minimum version is satisfied and what should be frequency of notifying user.

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
    public func checkForUpdatesFromURL(
        _ URL: URL,
        httpHeaderFields: NSDictionary?,
        newVersion: @escaping NewVersionBlock,
        noNewVersion: @escaping NoNewVersionBlock,
        error: @escaping ObjectErrorBlock
        ) -> URLSessionDataTask? {
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
     It also checks if minimum version is satisfied and what should be frequency of notifying user.

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
    public func checkForUpdatesFromURL(
        _ URL: URL,
        shouldPinCertificates: Bool,
        newVersion: @escaping NewVersionBlock,
        noNewVersion: @escaping NoNewVersionBlock,
        error: @escaping ObjectErrorBlock
        ) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdates(
            from: URL,
            httpHeaderFields: nil,
            shouldPinCertificates: shouldPinCertificates,
            newVersion: newVersion,
            noNewVersion: noNewVersion,
            error: error
        )
    }

    // All options

    /**
     Used for getting the automated information about update availability from URL. Can set custom http fields and activate certificates pinning.

     This method checks mimum required version, current installed version on device and current available version of the app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user.

     - parameter URL: URL that containts configuration data.
     - parameter httpHeaderFields: Optional HTTP header fields.
     - parameter shouldPinCertificates: Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
     - parameter newVersion: The completion handler to call when the load request is complete in case if new version is available. It returns result that contains info about new optional or non-optional available version, as well as info if minimum version is satisfied
     - parameter noNewVersion: The completion handler to call when the load request is complete in case if there is no new versions available. It returns result that contains if minimum version is satisfied.

     - returns: Discardable `URLSessionDataTask`
     */
    @available(swift, obsoleted: 1.0)
    @objc(checkForUpdatesFromURL:httpHeaderFields:shouldPinCertificates:newVersion:noNewVersion:error:)
    @discardableResult
    public func checkForUpdatesFromURL(
        _ URL: URL,
        httpHeaderFields: NSDictionary?,
        shouldPinCertificates: Bool,
        newVersion: @escaping NewVersionBlock,
        noNewVersion: @escaping NoNewVersionBlock,
        error: @escaping ObjectErrorBlock
        ) -> URLSessionDataTask? {
        return self.internalyCheckAndPrepareForUpdates(
            from: URL,
            httpHeaderFields: httpHeaderFields,
            shouldPinCertificates: shouldPinCertificates,
            newVersion: newVersion,
            noNewVersion: noNewVersion,
            error: error
        )
    }
}

// MARK: - Private methods -

private extension PrinceOfVersions {

    // MARK: Load configuration

    func internalyLoadAndPrepareConfiguration(
        from URL: URL,
        httpHeaderFields: NSDictionary?,
        shouldPinCertificates: Bool,
        delegateQueue: OperationQueue?,
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
        },
            delegateQueue: delegateQueue)
    }

    // MARK: Check updates

    func internalyCheckAndPrepareForUpdates(
        from URL: URL,
        httpHeaderFields: NSDictionary?,
        shouldPinCertificates: Bool,
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
            newVersion: newVersion,
            noNewVersion: noNewVersion,
            error: { (checkError) in
                error((checkError as NSError))
            })
    }

    // MARK: Helpers

    func checkHeadersValidity(from headers: NSDictionary?) -> Result<[String: String?]?, NSError> {

        if headers == nil { return .success(nil) }

        if let httpHeaderFields = headers as? [String : String?] {
            return .success(httpHeaderFields)
        }

        return .failure((UpdateInfoError.unknown("httpHeaderFields value should be in @{NSString : NSString} format.") as NSError))
    }
}

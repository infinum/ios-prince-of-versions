//
//  AppVersionChecker.swift
//  AppVersionChecker
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit

public struct PrinceOfVersions {

    public enum Result {
        case success(UpdateInfo)
        case failure(Error)
    }

    public struct UpdateInfoResponse {

        /// The server's response to the URL request.
        public let response: URLResponse?

        /// The result of response serialization.
        public let result: Result
    }

    public typealias CompletionBlock = (UpdateInfoResponse) -> Void
    public typealias NewVersionBlock = (Version, Bool, [String: Any]?) -> Void
    public typealias NoNewVersionBlock = (Bool, [String: Any]?) -> Void
    public typealias ErrorBlock = (Error) -> Void

    public init(){}

    /**
     Check mimum required version, current installed version on device and current available version of the app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user.
     
     - parameters:
        - configurationURL: URL that containts configuration data
        - completion:       The completion handler to call when the load request is complete. 

            This completion handler takes the following parameters:

            `data`
                            
            Parsed data returned by the server.
                            
            `error`
                            
            An error object that indicates why the request failed, or nil if the request was successful.

     - returns: Configuration data
     */
    @discardableResult
    public func loadConfiguration(from URL: URL, completion: @escaping CompletionBlock) -> URLSessionDataTask {

        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = defaultSession.dataTask(with: URL, completionHandler: { (data, response, error) in

            let result: Result
            if let error = error {
                result = Result.failure(error)
            } else {
                do {
                    let updateInfo = try UpdateInfo(data: data)
                    result = Result.success(updateInfo)
                } catch let error {
                    result = Result.failure(error)
                }
            }
            let updateInfoResponse = UpdateInfoResponse(
                response: response,
                result: result
            )
            completion(updateInfoResponse)
        })
        dataTask.resume()
        return dataTask
    }

    @discardableResult
    func checkForUpdates(
        from URL: URL,
        newVersion: @escaping NewVersionBlock,
        noNewVersion: @escaping NoNewVersionBlock,
        error: @escaping ErrorBlock)
        -> URLSessionDataTask
    {

        return loadConfiguration(from: URL, completion: { (response) in
            switch response.result {
            case .failure(let updateInfoError):
                error(updateInfoError)

            case .success(let info):
                guard let latestVersion = info.latestVersion else {
                    noNewVersion(info.isMinimumVersionSatisfied, info.metadata)
                    return
                }

                if (latestVersion > info.installedVersion) && (!latestVersion.wasNotified || info.notificationType == .always) {
                    newVersion(latestVersion, info.isMinimumVersionSatisfied, info.metadata)
                    latestVersion.markNotified()
                } else {
                    noNewVersion(info.isMinimumVersionSatisfied, info.metadata)
                }
            }
        })
    }

}

//
//  AppVersionChecker.swift
//  AppVersionChecker
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import Foundation

public class PrinceOfVersions: NSObject {

    // MARK: - Public properties -
    
    public typealias CompletionBlock = (UpdateResultResponse) -> Void
    public typealias AppStoreCompletionBlock = (Result<AppStoreUpdateResult, PoVError>) -> Void

    // MARK: - Private properties

    private var shouldPinCertificates: Bool = false
}

// MARK: - Public methods -

public extension PrinceOfVersions {

    /**
     Used for getting the versioning configuration stored on server.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.
     If configuration URL could not be provided, you can use `checkForUpdateFromAppStore` for automated check if new version is available.

     - parameter URL: URL that containts configuration data.
     - parameter callbackQueue: The queue on which the completion handler is dispatched. By default, `main` queue is used.
     - parameter options: Used for additional configuration such as `shouldPinCertificates`, `httpHeaderFields` and `userRequirements`
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdateResult data or PoVError error

     - returns: Discardable `URLSessionDataTask`
     */
    @discardableResult
    static func checkForUpdates(
        from URL: URL,
        callbackQueue: DispatchQueue = .main,
        options: PoVRequestOptions = PoVRequestOptions(),
        completion: @escaping CompletionBlock
    ) -> URLSessionDataTask {

        let princeOfVersions = PrinceOfVersions()
        princeOfVersions.shouldPinCertificates = options.shouldPinCertificates

        let defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: princeOfVersions, delegateQueue: nil)

        let request = princeOfVersions.createRequest(for: URL, headerFields: options.httpHeaderFields)

        let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in

            if let error = error {

                let updateInfoResponse = UpdateResultResponse(
                    response: response,
                    result: Result.failure(.unknown(error.localizedDescription))
                )

                callbackQueue.async {
                    completion(updateInfoResponse)
                }

                return
            }

            let result = princeOfVersions.decode(data: data, options: options)

            let updateInfoResponse = UpdateResultResponse(
                response: response,
                result: result
            )

            callbackQueue.async {
                completion(updateInfoResponse)
            }

        })
        dataTask.resume()

        /// Call to `finishTasksAndInvalidate` will break the connection with delegate
        /// and avoid memory leak. It is safe to call it immediately after dataTask
        /// resume() call since it won't cancel running task.
        defaultSession.finishTasksAndInvalidate()

        return dataTask
    }

    /**
     Used for getting the versioning information from the AppStore Connect.

     After check with server is finished, this method will return all informations about the app versioning available on AppStore Connect.
     It's up to the user to handle that info in a way sutable for the app.

     Update status can only take on value `UpdateStatus.noUpdateAvailable` or `UpdateStatus.newUpdateAvailable`, but it can't be `UpdateStatus.requiredUpdateNeeded` since there is no way to determine if the update version is mandatory with this check.

     If flag `trackPhaseRelease` is set to `false`, the value of the `phaseReleaseInProgress` will instantly be `false` as phased release is not used.
     Otherwise, if we have to check `trackPhaseRelease`, value of `phaseReleaseInProgress` will return `false` once phased release period of 7 days is over.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), if `trackPhaseRelease` is enabled `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value set on AppStore Connect.

     If parameter `notificationFrequency` is set to `.always`  and latest version of the app is bigger than installed version, method will always return `.newUpdateAvailable`. However, if the`notificationFrequency` is set to `.once`, only first time this method is called for the same latest app version, it will return `.newUpdateAvailable`, each subsequent call, it will return `.noUpdateAvailable`.

     - parameter trackPhaseRelease: Boolean that indicates whether PoV should notify about new version after 7 days when app is fully rolled out or immediately. Default value is `true`.
     - parameter bundle: Bundle where .plist file is stored in which app identifier and app versions should be checked.
     - parameter callbackQueue: The queue on which the completion handler is dispatched. By default, `main` queue is used.
     - parameter notificationFrequency: Determines update status appearance frequency.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data or PoVError error.

     - returns: Discardable `URLSessionDataTask`
     */
    @discardableResult
    static func checkForUpdateFromAppStore(
        trackPhaseRelease: Bool = true,
        bundle: Bundle = .main,
        callbackQueue: DispatchQueue = .main,
        notificationFrequency: NotificationType = .always,
        completion: @escaping AppStoreCompletionBlock
    ) -> URLSessionDataTask? {

        guard
            let bundleIdentifier = bundle.bundleIdentifier,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleIdentifier)")
        else {
            callbackQueue.async {
                completion(Result.failure(PoVError.invalidJsonData))
            }
            return nil
        }

        return internalyGetDataFromAppStore(
            url,
            trackPhaseRelease: trackPhaseRelease,
            bundle: bundle,
            callbackQueue: callbackQueue,
            notificationFrequency: notificationFrequency,
            completion: completion
        )
    }
}

// MARK: - Internal helpers -

internal extension PrinceOfVersions {

    @discardableResult
    static func internalyGetDataFromAppStore(
        _ url: URL,
        trackPhaseRelease: Bool = true,
        bundle: Bundle = .main,
        callbackQueue: DispatchQueue = .main,
        notificationFrequency: NotificationType = .always,
        testMode: Bool = false,
        completion: @escaping AppStoreCompletionBlock
    ) -> URLSessionDataTask? {

        let princeOfVersions = PrinceOfVersions()

        let defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: princeOfVersions, delegateQueue: nil)

        guard !testMode else {
            callbackQueue.async {
                let appStoreData = PrinceOfVersions.prepareAppStoreData(
                    from: try? Data(contentsOf: url),
                    error: nil,
                    bundle: bundle,
                    trackPhaseRelease: trackPhaseRelease,
                    notificationFrequency: notificationFrequency
                )
                completion(appStoreData)
            }
            return nil
        }

        let dataTask = defaultSession.dataTask(with: URLRequest(url: url), completionHandler: { (data, /* response */_, error) in
            callbackQueue.async {
                let appStoreData = PrinceOfVersions.prepareAppStoreData(
                    from: data,
                    error: error,
                    bundle: bundle,
                    trackPhaseRelease: trackPhaseRelease,
                    notificationFrequency: notificationFrequency
                )
                completion(appStoreData)
            }
        })

        dataTask.resume()

        /// Call to `finishTasksAndInvalidate` will break the connection with delegate
        /// and avoid memory leak. It is safe to call it immediately after dataTask
        /// resume() call since it won't cancel running task.
        defaultSession.finishTasksAndInvalidate()

        return dataTask
    }
}

// MARK: - Private helpers -

private extension PrinceOfVersions {

    func createRequest(for URL: URL, headerFields: NSDictionary?) -> URLRequest {

        guard let headerFields = headerFields as? [String : String] else {
            return URLRequest(url: URL)
        }

        var request = URLRequest(url: URL)
        for (fieldName, fieldValue) in headerFields {
            request.setValue(fieldValue, forHTTPHeaderField: fieldName)
        }

        return request
    }

    func decode(data: Data?, options: PoVRequestOptions) -> Result<UpdateResult, PoVError> {

        guard let data = data else {
            return .failure(.dataNotFound)
        }

        var result: Result<UpdateResult, PoVError>

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            var updateInfo = try decoder.decode(UpdateInfo.self, from: data)
            updateInfo.userRequirements = options.userRequirements

            if let error = PoVError.validate(updateInfo: updateInfo) {
                result = Result.failure(error)
            } else {
                let updateResult = UpdateResult(updateInfo: updateInfo)
                result = Result.success(updateResult)
            }

        } catch _ {
            result = Result.failure(.invalidJsonData)
        }

        return result
    }

    func certificates(in bundle: Bundle = .main) -> [SecCertificate] {
        let paths = [".cer", ".CER", ".crt", ".CRT", ".der", ".DER"]
            .map { bundle.paths(forResourcesOfType: $0, inDirectory: nil) }
            .joined()

        /// Remove duplicates and extract certificate data from it
        return Set(paths)
            .compactMap { try? Data(contentsOf: URL(fileURLWithPath: $0)) as CFData }
            .compactMap { SecCertificateCreateWithData(nil, $0) }
    }

    func pinnedKeys() -> [SecKey] {
        return certificates()
            .compactMap { publicKey(for: $0) }
    }

    func publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?

        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)

        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }

        return publicKey
    }

    static func prepareAppStoreData(from data: Data?, error: Error?, bundle: Bundle, trackPhaseRelease: Bool, notificationFrequency: NotificationType) -> Result<AppStoreUpdateResult, PoVError> {

        if let error = error {
            return Result.failure(.unknown(error.localizedDescription))
        }

        let result: Result<AppStoreUpdateResult, PoVError>
        do {

            AppStoreUpdateInfo.bundle = bundle

            var updateInfo = try JSONDecoder().decode(AppStoreUpdateInfo.self, from: data!)
            updateInfo.notificationFrequency = notificationFrequency

            if let error = PoVError.validate(appStoreInfo: updateInfo) {
                result = Result.failure(error)
            } else {
                result = Result.success(AppStoreUpdateResult(updateInfo: updateInfo))
            }

        } catch let error {
            var errorDescription = error.localizedDescription
            if let PoVError = (error as? PoVError),
                case .dataNotFound = PoVError {
                errorDescription += ": \(bundle.bundleIdentifier ?? "bundle identifier not found")"
            }
            result = Result.failure(.unknown(errorDescription))
        }

        return result
    }
}

// MARK: - URLSessionDelegate -

extension PrinceOfVersions: URLSessionDelegate {

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        guard shouldPinCertificates else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        if
            let serverCertificate = SecTrustGetCertificateAtIndex(trust, 0),
            let serverCertificateKey = publicKey(for: serverCertificate)
        {
            let hasKey = pinnedKeys().contains(where: { (key) -> Bool in
                return (serverCertificateKey as AnyObject).isEqual(key)
            })

            if hasKey {
                completionHandler(.useCredential, URLCredential(trust: trust))
                return
            }
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }

}

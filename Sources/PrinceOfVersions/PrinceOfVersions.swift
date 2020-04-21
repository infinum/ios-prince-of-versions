//
//  AppVersionChecker.swift
//  AppVersionChecker
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import Foundation

public class PrinceOfVersions: NSObject {

    // MARK: - Public interface

    public struct UpdateResultResponse {

        /// The server's response to the URL request.
        public let response: URLResponse?

        /// The result of response serialization.
        public let result: Result<UpdateResult, PrinceOfVersionsError>
    }

    public typealias CompletionBlock = (UpdateResultResponse) -> Void
    public typealias AppStoreCompletionBlock = (Result<AppStoreInfo, PrinceOfVersionsError>) -> Void

    // MARK: - Internal properties

    var options: PoVOptions

    // MARK: - Private properties

    private var shouldPinCertificates: Bool = false

    // MARK: - Init

    public init(with options: PoVOptions? = nil) {
        self.options = options ?? PoVOptions()
    }

    @available(swift, obsoleted: 1.0)
    public override init() {
        self.options = PoVOptions()
    }

    @available(swift, obsoleted: 1.0)
    @objc(initWithOptions:)
    public init(with options: PoVOptions) {
        self.options = options
    }
}

// MARK: - Public methods -

public extension PrinceOfVersions {

    /**
     Used for getting the versioning configuration stored on server.

     After check with server is finished, this method will return all informations about the app versioning.
     It's up to the user to handle that info in a way sutable for the app.
     If configuration URL could not be provided, you can use `checkForUpdateFromAppStore` for automated check if new version is available.

     - parameter URL: URL that containts configuration data.
     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdateResult data or PrinceOfVersionsError error

     - returns: Discardable `URLSessionDataTask`
     */
    @discardableResult
    func checkForUpdates(from URL: URL, completion: @escaping CompletionBlock) -> URLSessionDataTask {

        shouldPinCertificates = options.shouldPinCertificates

        let defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: URL)

        if let headerFields = options.httpHeaderFields {
            for (fieldName, fieldValue) in headerFields {
                if let fieldValue = fieldValue as? String, let fieldName = fieldName as? String {
                    request.setValue(fieldValue, forHTTPHeaderField: fieldName)
                }
            }
        }

        let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in

            let result: Result<UpdateResult, PrinceOfVersionsError>
            if let error = error {
                result = Result.failure(.unknown(error.localizedDescription))
            } else {
                do {
                    var updateInfo = try JSONDecoder().decode(UpdateInfo.self, from: data!)
                    updateInfo.userRequirements = self.options.userRequirements

                    let updateResult = UpdateResult(updateInfo: updateInfo)

                    if let error = updateResult.validate() {
                        result = Result.failure(error)
                    } else {
                        result = Result.success(updateResult)
                    }

                } catch _ {
                    result = Result.failure(.invalidJsonData)
                }
            }

            let updateInfoResponse = UpdateResultResponse(
                response: response,
                result: result
            )
            self.options.callbackQueue.async {
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

     - parameter completion: The completion handler to call when the load request is complete. It returns result that contains UpdatInfo data or PrinceOfVersionsError error

     - returns: Discardable `URLSessionDataTask`
     */
    @discardableResult
    func checkForUpdateFromAppStore(completion: @escaping AppStoreCompletionBlock) -> URLSessionDataTask? {

        guard
            let bundleIdentifier = options.bundle.bundleIdentifier,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleIdentifier)")
        else {
            options.callbackQueue.async {
                completion(Result.failure(PrinceOfVersionsError.invalidJsonData))
            }
            return nil
        }

        return internalyGetDataFromAppStore(url, completion: completion)
    }
}

// MARK: - Internal helpers -

internal extension PrinceOfVersions {

    @discardableResult
    func internalyGetDataFromAppStore(
        _ url: URL,
        testMode: Bool = false,
        completion: @escaping AppStoreCompletionBlock
    ) -> URLSessionDataTask? {

        let defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)

        guard !testMode else {
            options.callbackQueue.async {
                let appStoreData = PrinceOfVersions.prepareAppStoreData(
                    from: try? Data(contentsOf: url),
                    error: nil,
                    bundle: self.options.bundle,
                    trackPhaseRelease: self.options.trackPhaseRelease
                )
                completion(appStoreData)
            }
            return nil
        }

        let dataTask = defaultSession.dataTask(with: URLRequest(url: url), completionHandler: { (data, /* response */_, error) in
            self.options.callbackQueue.async {
                let appStoreData = PrinceOfVersions.prepareAppStoreData(
                    from: data,
                    error: error,
                    bundle: self.options.bundle,
                    trackPhaseRelease: self.options.trackPhaseRelease
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

    static func prepareAppStoreData(from data: Data?, error: Error?, bundle: Bundle, trackPhaseRelease: Bool) -> Result<AppStoreInfo, PrinceOfVersionsError> {

        if let error = error {
            return Result.failure(.unknown(error.localizedDescription))
        }

        let result: Result<AppStoreInfo, PrinceOfVersionsError>
        do {
            
            var updateInfo = try JSONDecoder().decode(AppStoreInfo.self, from: data!)

            if let error = updateInfo.validate() {
                result = Result.failure(error)
            } else {
                updateInfo.bundle = bundle
                result = Result.success(updateInfo)
            }

        } catch let error {
            var errorDescription = error.localizedDescription
            if let princeOfVersionsError = (error as? PrinceOfVersionsError),
                case .dataNotFound = princeOfVersionsError {
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

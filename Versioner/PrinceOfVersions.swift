//
//  AppVersionChecker.swift
//  AppVersionChecker
//
//  Created by Jasmin Abou Aldan on 21/06/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

import UIKit

public class PrinceOfVersions: NSObject {

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

    private var _shouldPinCertificates: Bool = false
    
    public override init() {
        super.init()
    }

    /**
     Check mimum required version, current installed version on device and current available version of the app with data stored on URL.
     It also checks if minimum version is satisfied and what should be frequency of notifying user.
     
     - parameters:
        - configurationURL:      URL that containts configuration data.
        - httpHeaderFields:      Optional HTTP header fields.
        - shouldPinCertificates: Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
        - completion:            The completion handler to call when the load request is complete.

            This completion handler takes the following parameters:

            `data`
                            
            Parsed data returned by the server.
                            
            `error`
                            
            An error object that indicates why the request failed, or nil if the request was successful.

     - returns: Configuration data
     */
    @discardableResult
    public func loadConfiguration(from URL: URL, httpHeaderFields: [String : String?]? = nil, shouldPinCertificates: Bool = false, completion: @escaping CompletionBlock, delegateQueue: OperationQueue? = nil) -> URLSessionDataTask {

        _shouldPinCertificates = shouldPinCertificates
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: delegateQueue)
        var request = URLRequest(url: URL)
        
        if let headerFields = httpHeaderFields {
            for (fieldName, fieldValue) in headerFields {
                request.setValue(fieldValue, forHTTPHeaderField: fieldName)
            }
        }
        
        let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in

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
    public func checkForUpdates(
        from URL: URL,
        httpHeaderFields: [String : String?]? = nil,
        pinnedCertificateURL: URL? = nil,
        newVersion: @escaping NewVersionBlock,
        noNewVersion: @escaping NoNewVersionBlock,
        error: @escaping ErrorBlock)
        -> URLSessionDataTask
    {

        return loadConfiguration(from: URL, httpHeaderFields: httpHeaderFields, completion: { (response) in
            switch response.result {
            case .failure(let updateInfoError):
                error(updateInfoError)

            case .success(let info):
                let latestVersion = info.latestVersion
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

extension PrinceOfVersions: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard _shouldPinCertificates else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        if let serverCertificate = SecTrustGetCertificateAtIndex(trust, 0), let serverCertificateKey = _publicKey(for: serverCertificate) {
            
            let hasKey = _pinnedKeys().contains(where: { (key) -> Bool in
                if (serverCertificateKey as AnyObject).isEqual(key) {
                    return true
                } else {
                    return false
                }
            })
            
            if hasKey {
                completionHandler(.useCredential, URLCredential(trust: trust))
                return
            }
        }
        
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    private func _certificates(in bundle: Bundle = Bundle.main) -> [SecCertificate] {
        var certificates: [SecCertificate] = []
        
        let paths = Set([".cer", ".CER", ".crt", ".CRT", ".der", ".DER"].map { fileExtension in
            bundle.paths(forResourcesOfType: fileExtension, inDirectory: nil)
            }.joined())
        
        for path in paths {
            if
                let certificateData = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData,
                let certificate = SecCertificateCreateWithData(nil, certificateData)
            {
                certificates.append(certificate)
            }
        }
        
        return certificates
    }
    
    private func _pinnedKeys() -> [SecKey] {
        var publicKeys: [SecKey] = []
        
        for certificate in _certificates() {
            if let key = _publicKey(for: certificate) {
                publicKeys.append(key)
            }
        }
        
        return publicKeys
    }
    
    private func _publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?
        
        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)
        
        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }
        
        return publicKey
    }
}

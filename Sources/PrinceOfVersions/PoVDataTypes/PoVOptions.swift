//
//  PoVOptions.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 20/04/2020.
//

import Foundation

@objcMembers
public class PoVOptions: NSObject {

    // MARK: - Public properties

    /// The queue on which the completion handler is dispatched. By default, `main` queue is used.
    public var callbackQueue: DispatchQueue = .main
    
    /// Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
    public var shouldPinCertificates: Bool = false

    /// Optional HTTP header fields.
    public var httpHeaderFields: NSDictionary?

    /**
     Boolean that indicates whether PoV should notify about new version after 7 days when app is fully rolled out or immediately. Default value is `true`.
     If flag `trackPhaseRelease` is set to `false`, the value of the `phaseReleaseInProgress` will instantly be `false` as phased release is not used.
     Otherwise, if we have to check `trackPhaseRelease`, value of `phaseReleaseInProgress` will return `false` once phased release period of 7 days is over.

     __WARNING:__ As we are not able to determine if phased release period is finished earlier (release to all options is selected after a while), if `trackPhaseRelease` is enabled `phaseReleaseInProgress` will return `false` only after 7 days of `currentVersionReleaseDate` value set on AppStore Connect.
     */
    public var trackPhaseRelease: Bool = true

    /// Bundle where .plist file is stored in which app identifier and app versions should be checked.
    public var bundle: Bundle = .main

    public func addRequirement(key: String, requirementCheck: @escaping ((Any) -> Bool)) {
        userRequirements.updateValue(requirementCheck, forKey: key)
    }

    // MARK: - Internal properties
    var userRequirements: [String: ((Any) -> Bool)] = [:]
}

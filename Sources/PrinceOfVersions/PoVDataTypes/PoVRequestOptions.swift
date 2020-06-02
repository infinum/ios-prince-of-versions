//
//  PoVRequestOptions.swift
//  PrinceOfVersions
//
//  Created by Ivana Mršić on 20/04/2020.
//

import Foundation

@objcMembers
public class PoVRequestOptions: NSObject {

    // MARK: - Public properties

    /// Boolean that indicates whether PoV should use security keys from all certificates found in the main bundle. Default value is `false`.
    public var shouldPinCertificates: Bool = false

    /// Optional HTTP header fields.
    public var httpHeaderFields: NSDictionary?

    // MARK: - Internal properties
    
    internal var userRequirements: [String: ((Any) -> Bool)] = [:]

    // MARK: - Public methods

    /**
    Adds requirement check for configuration.

     Use this method to add custom requirement by which configuration must comply with.

     - parameter key: String that matches key in requirements array in JSON with `requirementsCheck` parameter,
     - parameter requirementCheck: A block used to check if a configuration meets requirement. This block returns `true` if configuration meets the requirement, and takes the any value as input parameter by which .

     */
    public func addRequirement(key: String, requirementCheck: @escaping ((Any) -> Bool)) {
        userRequirements.updateValue(requirementCheck, forKey: key)
    }

}

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

    /// HTTP header fields.
    public private(set) var httpHeaderFields: NSMutableDictionary = [:]

    /// Adds value to httpHeaderFields dictionary
    @objc(setValue:forHttpHeaderField:)
    public func set(value: NSString, httpHeaderField: NSString) {
        httpHeaderFields.setObject(value, forKey: httpHeaderField)
    }

    // MARK: - Internal properties
    
    internal var userRequirements: [String: ((Any) -> Bool)] = [:]

    // MARK: - Public methods

    /**
     Adds requirement check for configuration.

     Use this method to add custom requirement by which configuration must comply with.

     - parameter key: String that matches key in requirements array in JSON with `requirementsCheck` parameter,
     - parameter type: The expected type of the value.
     - parameter requirementCheck: A block used to check if a configuration meets the requirement. This block returns `true` if the configuration meets the requirement, and takes the typed value as input.

     */
    public func addRequirement<T>(key: String, ofType type: T.Type, requirementCheck: @escaping (T) -> Bool) {
        userRequirements.updateValue({ value in
            guard let typedValue = value as? T else { return false }
            return requirementCheck(typedValue)
        }, forKey: key)
    }

    /**
     Adds requirement check for configuration (Objective-C compatible).

     Use this method to add a custom requirement by which configuration must comply with.

     - parameter key: String that matches the key in the requirements array in JSON with the `requirementCheck` parameter.
     - parameter type: The expected class of the value (e.g., `NSString.class`).
     - parameter requirementCheck: A block used to check if a configuration meets the requirement. This block returns `true` if the configuration meets the requirement, and takes the value as input.

     This method is designed for Objective-C compatibility and uses runtime type checking (`isKindOfClass:`) to validate the value.
     */
    @available(swift, obsoleted: 1.0, message: "Use the generic addRequirement(key:ofType:requirementCheck:) method in Swift.")
    @objc(addRequirementWithKey:ofType:requirementCheck:)
    public func addRequirementWithKey(key: String, ofType type: AnyClass, requirementCheck: @escaping (Any) -> Bool) {
        userRequirements.updateValue({ value in
            guard let value = value as? NSObject, value.isKind(of: type) else { return false }
            return requirementCheck(value)
        }, forKey: key)
    }

}

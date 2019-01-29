// ----------------------------------------------------------------------------
//
//  StringToDoubleTransform.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------


public final class StringToDoubleTransform: TransformType
{
    public typealias Object = Double
    public typealias JSON = String

// MARK: - Construction

    public static let shared = StringToDoubleTransform()

    private init() {
        // Do nothing
    }

// MARK: - Methods

    public func transformFromJSON(_ value: Any?) -> Double? {
        var result: Double?

        if let stringValue = (value as? String), stringValue.isNotEmpty {
            result = Double(stringValue)
        }

        // Done
        return result
    }

    public func transformToJSON(_ value: Double?) -> String? {
        var result: String?

        if let number = value {
            result = "\(number)"
        }

        // Done
        return result
    }
}

// ----------------------------------------------------------------------------


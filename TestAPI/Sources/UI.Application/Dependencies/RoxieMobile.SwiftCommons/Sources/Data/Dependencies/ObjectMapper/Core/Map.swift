//
//  Map.swift
//  ObjectMapper
//
//  Created by Tristan Himmelman on 2015-10-09.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-2016 Hearst
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import Foundation

/// MapContext is available for developers who wish to pass information around during the mapping process.
public protocol MapContext {

}

/// A class used for holding mapping data
public final class Map {
    public let mappingType: MappingType

    public internal(set) var JSON: [String: Any] = [:]
    public internal(set) var isKeyPresent = false
    public internal(set) var currentValue: Any?
    public internal(set) var currentKey: String?
    var keyIsNested = false
    public internal(set) var nestedKeyDelimiter: String = "."
    public var context: MapContext?
    public var shouldIncludeNilValues = false  /// If this is set to true, toJSON output will include null values for any variables that are not set.

    public let toObject: Bool // indicates whether the mapping is being applied to an existing object

    public init(mappingType: MappingType, JSON: [String: Any], toObject: Bool = false, context: MapContext? = nil, shouldIncludeNilValues: Bool = false) {

        self.mappingType = mappingType
        self.JSON = JSON
        self.toObject = toObject
        self.context = context
        self.shouldIncludeNilValues = shouldIncludeNilValues
    }

    /// Sets the current mapper value and key.
    /// The Key parameter can be a period separated string (ex. "distance.value") to access sub objects.
    public subscript(key: String) -> Map {
        // save key and value associated to it
        return self.subscript(key: key)
    }

    public subscript(key: String, delimiter delimiter: String) -> Map {
        return self.subscript(key: key, delimiter: delimiter)
    }

    public subscript(key: String, nested nested: Bool) -> Map {
        return self.subscript(key: key, nested: nested)
    }

    public subscript(key: String, nested nested: Bool, delimiter delimiter: String) -> Map {
        return self.subscript(key: key, nested: nested, delimiter: delimiter)
    }

    public subscript(key: String, ignoreNil ignoreNil: Bool) -> Map {
        return self.subscript(key: key, ignoreNil: ignoreNil)
    }

    public subscript(key: String, delimiter delimiter: String, ignoreNil ignoreNil: Bool) -> Map {
        return self.subscript(key: key, delimiter: delimiter, ignoreNil: ignoreNil)
    }

    public subscript(key: String, nested nested: Bool, ignoreNil ignoreNil: Bool) -> Map {
        return self.subscript(key: key, nested: nested, ignoreNil: ignoreNil)
    }

    public subscript(key: String, nested nested: Bool?, delimiter delimiter: String, ignoreNil ignoreNil: Bool) -> Map {
        return self.subscript(key: key, nested: nested, delimiter: delimiter, ignoreNil: ignoreNil)
    }

    private func `subscript`(key: String, nested: Bool? = nil, delimiter: String = ".", ignoreNil: Bool = false) -> Map {
        // Save key and value associated to it
        self.currentKey = key
        self.keyIsNested = nested ?? key.contains(delimiter)
        self.nestedKeyDelimiter = delimiter

        switch self.mappingType {
            case .fromJSON:
                (self.isKeyPresent, self.currentValue) = fetch(valueFor: self.currentKey!,
                        nested: self.keyIsNested, delimiter: self.nestedKeyDelimiter, ignoreNil: ignoreNil)
            default: ()
        }

        // Done
        return self
    }

    internal func fetch(valueFor key: String, nested: Bool? = nil, delimiter: String = ".", ignoreNil: Bool = false) -> (keyExists: Bool, value: Any?) {
        var result: (keyExists: Bool, value: Any?) = (false, nil)

        // Check if a value exists for the passed key. Do this pre-check for performance reasons
        if nested ?? key.contains(delimiter) {
            result = valueFor(ArraySlice(key.components(separatedBy: delimiter)), dictionary: self.JSON)
        }
        else {
            let object = self.JSON[key]
            let isNSNull = object is NSNull
            result = (isNSNull || (object != nil), isNSNull ? nil : object)
        }

        // Update `result.keyExists` if `ignoreNil` is true
        if ignoreNil && (result.value == nil) {
            result = (false, nil)
        }

        // Done
        return result
    }

    public func value<T>() -> T? {
        let value = self.currentValue as? T

        // Swift 4.1 breaks Float casting from `NSNumber`. So Added extra checks for `Float` `[Float]` and `[String:Float]`
        if value == nil && T.self == Float.self {
            if let v = self.currentValue as? NSNumber {
                return v.floatValue as? T
            }
        } else if value == nil && T.self == [Float].self {
            if let v = self.currentValue as? [Double] {
// Code targeting the Swift 4.1 compiler and above.
#if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
                return v.compactMap{ Float($0) } as? T
#else
                return v.flatMap{ Float($0) } as? T
#endif
            }
        } else if value == nil && T.self == [String:Float].self {
            if let v = self.currentValue as? [String:Double] {
                return v.mapValues{ Float($0) } as? T
            }
        }
        return value
    }
}

/// Fetch value from JSON dictionary, loop through keyPathComponents until we reach the desired object
private func valueFor(_ keyPathComponents: ArraySlice<String>, dictionary: [String: Any]) -> (Bool, Any?) {
    // Implement it as a tail recursive function.
    if keyPathComponents.isEmpty {
        return (false, nil)
    }

    if let keyPath = keyPathComponents.first {
        let isTail = keyPathComponents.count == 1
        let object = dictionary[keyPath]
        if object is NSNull {
            return (isTail, nil)
        } else if keyPathComponents.count > 1, let dict = object as? [String: Any] {
            let tail = keyPathComponents.dropFirst()
            return valueFor(tail, dictionary: dict)
        } else if keyPathComponents.count > 1, let array = object as? [Any] {
            let tail = keyPathComponents.dropFirst()
            return valueFor(tail, array: array)
        } else {
            return (isTail && object != nil, object)
        }
    }

    return (false, nil)
}

/// Fetch value from JSON Array, loop through keyPathComponents them until we reach the desired object
private func valueFor(_ keyPathComponents: ArraySlice<String>, array: [Any]) -> (Bool, Any?) {
    // Implement it as a tail recursive function.

    if keyPathComponents.isEmpty {
        return (false, nil)
    }

    //Try to convert keypath to Int as index
    if let keyPath = keyPathComponents.first,
        let index = Int(keyPath) , index >= 0 && index < array.count {

        let isTail = keyPathComponents.count == 1
        let object = array[index]

        if object is NSNull {
            return (isTail, nil)
        } else if keyPathComponents.count > 1, let array = object as? [Any]  {
            let tail = keyPathComponents.dropFirst()
            return valueFor(tail, array: array)
        } else if  keyPathComponents.count > 1, let dict = object as? [String: Any] {
            let tail = keyPathComponents.dropFirst()
            return valueFor(tail, dictionary: dict)
        } else {
            return (isTail, object)
        }
    }

    return (false, nil)
}
// ----------------------------------------------------------------------------
//
//  NestedError.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

//import SwiftCommonsLang

// ----------------------------------------------------------------------------

public protocol NestedError: Error, CustomStringConvertible, CustomDebugStringConvertible
{
// MARK: - Properties

    var cause: Error? { get }
}

// ----------------------------------------------------------------------------

extension NestedError
{
// MARK: - Properties

    public var description: String
    {
        var result = Roxie.typeName(of: self)
        if let cause = self.cause {
            result += "\nCaused by error: " + String(describing: cause).trim()
        }

        return result
    }

    public var debugDescription: String {
        return self.description
    }
}

// ----------------------------------------------------------------------------

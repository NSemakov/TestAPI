// ----------------------------------------------------------------------------
//
//  HttpAuthentication.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

//import SwiftCommonsLang

// ----------------------------------------------------------------------------

open class HttpAuthentication: AbstractClass
{
// MARK: - Functions

    open func getHeaderValue() -> String {
        raiseAbstractMethodException()
    }
}

// ----------------------------------------------------------------------------
// MARK: - @protocol Printable, DebugPrintable
// ----------------------------------------------------------------------------

extension HttpAuthentication: CustomStringConvertible, CustomDebugStringConvertible
{
// MARK: - Properties

    public var description: String {
        return "Authorization: " + getHeaderValue()
    }

    public var debugDescription: String {
        return self.description
    }
}

// ----------------------------------------------------------------------------

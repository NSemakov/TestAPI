// ----------------------------------------------------------------------------
//
//  ConnectionError.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

open class ConnectionError: NestedError
{
// MARK: - Construction

    public init(cause: Error?)
    {
        // Init instance variables
        self.cause = cause
    }

// MARK: - Properties

    public let cause: Error?

}

// ----------------------------------------------------------------------------

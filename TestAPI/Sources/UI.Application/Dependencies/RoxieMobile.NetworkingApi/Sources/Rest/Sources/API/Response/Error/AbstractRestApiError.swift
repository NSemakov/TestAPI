// ----------------------------------------------------------------------------
//
//  AbstractRestApiError.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

//import SwiftCommonsLang

// ----------------------------------------------------------------------------

open class AbstractRestApiError: RestApiError, AbstractClass
{
// MARK: - Construction

    public init(cause: Error?)
    {
        // Init instance variables
        self.cause = cause
    }

// MARK: - Properties

    open var type: RestApiErrorType {
        raiseAbstractMethodException()
    }

    public let cause: Error?
}

// ----------------------------------------------------------------------------

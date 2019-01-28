// ----------------------------------------------------------------------------
//
//  Call.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

//import SwiftCommonsLang

// ----------------------------------------------------------------------------

// FIXME: Should be generic protocol!

// ----------------------------------------------------------------------------

open class Call<T>: AbstractClass
{
// MARK: - Construction

    public init() {
        // Do nothing
    }

// MARK: - Properties

    open func getTag() -> String {
        raiseAbstractMethodException()
    }

    open func getRequestEntity() -> RequestEntity<T> {
        raiseAbstractMethodException()
    }

}

// ----------------------------------------------------------------------------

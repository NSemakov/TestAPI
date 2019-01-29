// ----------------------------------------------------------------------------
//
//  Callback.swift
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

open class Callback<Ti, To>: AbstractClass
{
// MARK: - Construction

    public init() {
        // Do nothing
    }

// MARK: - Functions

    open func onShouldExecute(_ call: Call<Ti>) -> Bool {
        raiseAbstractMethodException()
    }

    open func onSuccess(_ call: Call<Ti>, entity: ResponseEntity<To>) {
        raiseAbstractMethodException()
    }

    open func onFailure(_ call: Call<Ti>, error: RestApiError) {
        raiseAbstractMethodException()
    }

    open func onCancel(_ call: Call<Ti>) {
        raiseAbstractMethodException()
    }

}

// ----------------------------------------------------------------------------

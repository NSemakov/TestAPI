// ----------------------------------------------------------------------------
//
//  TaskBuilder.swift
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

open class TaskBuilder<Ti, To>: AbstractClass
{
// MARK: - Properties

    open func getTag() -> String {
        raiseAbstractMethodException()
    }

    open func getRequestEntity() -> RequestEntity<Ti> {
        raiseAbstractMethodException()
    }

// MARK: - Functions

    open func build() -> Task<Ti, To> {
        raiseAbstractMethodException()
    }

}

// ----------------------------------------------------------------------------

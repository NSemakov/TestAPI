// ----------------------------------------------------------------------------
//
//  Cancellable.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

public protocol Cancellable: class
{
// MARK: - Functions

    @discardableResult func cancel() -> Bool

}

// ----------------------------------------------------------------------------

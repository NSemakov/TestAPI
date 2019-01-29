// ----------------------------------------------------------------------------
//
//  EndpointManager.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation


// ----------------------------------------------------------------------------
// TODO: Refactoring is needed
// ----------------------------------------------------------------------------

class EndpointManager
{
// MARK: - Construction

    static let defaultManager = EndpointManager()

    private init() { }

// MARK: - Properties

    var baseURL: URL? {
        return URL(string: "https://bnet.i-partner.ru/testAPI/")
    }

// MARK: - Methods

    // ...

// MARK: - Actions

    // ...

// MARK: - Private Methods

    // ...

// MARK: - Constants

    // ...

// MARK: - Variables

    // ...

}

// ----------------------------------------------------------------------------

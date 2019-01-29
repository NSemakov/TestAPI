// ----------------------------------------------------------------------------
//
//  DefaultHttpHeaders.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class DefaultHttpHeaders: NonCreatable
{
// MARK: - Methods

    static func headers(_ token: String? = nil) -> HttpHeaders
    {
        var headers = HttpHeaders()

        if let token = token {
            // Build headers
            headers.set(HttpHeaders.Header.Token, value: token)
        }

        // Done
        return headers
    }

// MARK: - Private Methods

    // ...

}

// ----------------------------------------------------------------------------

extension HttpHeaders.Header
{
// MARK: - Constants

    public static let Token = "token"

}

// ----------------------------------------------------------------------------

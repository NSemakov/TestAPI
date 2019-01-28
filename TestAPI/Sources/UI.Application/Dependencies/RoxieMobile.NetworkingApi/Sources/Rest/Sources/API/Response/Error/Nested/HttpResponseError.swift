// ----------------------------------------------------------------------------
//
//  HttpResponseError.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

open class HttpResponseError: Error
{
// MARK: - Construction

    public init(httpResponse: HttpResponse)
    {
        // Init instance variables
        self.httpResponse = httpResponse
    }

// MARK: - Properties

    public let httpResponse: HttpResponse

}

// ----------------------------------------------------------------------------

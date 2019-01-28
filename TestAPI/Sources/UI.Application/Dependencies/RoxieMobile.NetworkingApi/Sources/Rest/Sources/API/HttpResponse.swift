// ----------------------------------------------------------------------------
//
//  HttpResponse.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

open class HttpResponse
{
// MARK: - Construction

    public init(response: HTTPURLResponse, body: Data? = nil, redirectRequest: URLRequest? = nil)
    {
        // Init instance variables
        self.response = response
        self.body = body
        self.redirectRequest = redirectRequest
    }

// MARK: - Properties

    public let response: HTTPURLResponse

    public let body: Data?

    public let redirectRequest: URLRequest?
}

// ----------------------------------------------------------------------------

extension HttpResponse
{
// MARK: - Construction

    func copy(body: Data?) -> HttpResponse {
        return HttpResponse(response: self.response, body: body, redirectRequest: self.redirectRequest)
    }
}

// ----------------------------------------------------------------------------

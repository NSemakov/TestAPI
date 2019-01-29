// ----------------------------------------------------------------------------
//
//  NoopRedirectInterceptor.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

open class NoopRedirectInterceptor: AbstractRedirectInterceptor
{
// MARK: - Functions

    open override func onRedirect(_ httpResponse: HttpResponse) throws -> HttpResponse {
        return httpResponse
    }

}

// ----------------------------------------------------------------------------

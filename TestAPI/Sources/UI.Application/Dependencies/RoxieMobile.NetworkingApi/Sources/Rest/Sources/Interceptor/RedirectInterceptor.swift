// ----------------------------------------------------------------------------
//
//  RedirectInterceptor.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

public protocol RedirectInterceptor: Interceptor
{
// MARK: - Functions

    func onRedirect(_ httpResponse: HttpResponse) throws -> HttpResponse

}

// ----------------------------------------------------------------------------

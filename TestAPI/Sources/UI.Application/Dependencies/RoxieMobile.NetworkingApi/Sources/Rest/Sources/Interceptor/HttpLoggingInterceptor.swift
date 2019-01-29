// ----------------------------------------------------------------------------
//
//  HttpLoggingInterceptor.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHelpers

// ----------------------------------------------------------------------------

open class HttpLoggingInterceptor: Interceptor
{
// MARK: - Functions

    open func intercept(_ chain: InterceptorChain) throws -> HttpResponse
    {
        // Log request
        LogUtils.log(Inner.TAG, request: chain.request)

        // Perform request
        let httpResponse = try chain.proceed(chain.request)

        // Log response
        LogUtils.log(Inner.TAG, response: httpResponse.response, body: httpResponse.body)

        // Done
        return httpResponse
    }

// MARK: - Constants

    private struct Inner {
        static let TAG = HttpLoggingInterceptor.self
    }

}

// ----------------------------------------------------------------------------

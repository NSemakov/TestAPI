// ----------------------------------------------------------------------------
//
//  UserAgentRequestInterceptor.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
////import NetworkingApiHttp
//import NetworkingApiObjC

// ----------------------------------------------------------------------------

public final class UserAgentRequestInterceptor: Interceptor
{
// MARK: - Methods

    public func intercept(_ chain: InterceptorChain) throws -> HttpResponse {
        var request = chain.request

        let userAgent = newUserAgent(headers: request.allHTTPHeaderFields)
        request.setValue(userAgent, forHTTPHeaderField: HttpHeaders.Header.UserAgent)

        return try chain.proceed(request)
    }

// MARK: - Private Methods

    private func newUserAgent(headers: [String: String]?) -> String {
        let userAgent: String

        if let originalUserAgent = headers?[HttpHeaders.Header.UserAgent] {
            userAgent = (originalUserAgent + " " + Inner.UserAgent)
        }
        else {
            userAgent = Inner.UserAgent
        }

        return userAgent
    }

// MARK: - Constants

    private struct Inner {
        static let UserAgent = DefaultUserAgent.value
    }
}

// ----------------------------------------------------------------------------

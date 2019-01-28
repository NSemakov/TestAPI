// ----------------------------------------------------------------------------
//
//  DefaultHttpClientConfig.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import SwiftCommonsLogging

// ----------------------------------------------------------------------------

open class DefaultHttpClientConfig: HttpClientConfig
{
// MARK: - Construction

    public init() {
        // Do nothing
    }

// MARK: - Methods

    open func connectTimeout() -> TimeInterval {
        return NetworkConfig.Timeout.Connection
    }

    open func readTimeout() -> TimeInterval {
        return NetworkConfig.Timeout.Connection
    }

    open func interceptors() -> [Interceptor] {
        return Inner.Interceptors
    }

    open func networkInterceptors() -> [Interceptor] {
        return Inner.NetworkInterceptors
    }

// MARK: - Constants

    fileprivate struct Inner
    {
        static let Interceptors: [Interceptor] = []

        static let NetworkInterceptors: [Interceptor] = {
            var networkInterceptors: [Interceptor] = []

            // Interceptor which adds an Alamofire library's version to an User-Agent's header
            networkInterceptors.append(UserAgentRequestInterceptor())

            // Interceptor which logs request and response information
            if Logger.isLoggable(.debug) {
                networkInterceptors.append(HttpLoggingInterceptor())
            }

            return networkInterceptors
        }()
    }

}

// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
//
//  CallServerInterceptor.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Alamofire
import Foundation
//import NetworkingApiHttp
////import SwiftCommonsDiagnostics
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

class CallServerInterceptor: Interceptor
{
// MARK: - Construction

    fileprivate init(builder: CallServerInterceptorBuilder)
    {
        // Init instance variables
        self.options = builder.options
    }

// MARK: - Functions

    func intercept(_ chain: InterceptorChain) throws -> HttpResponse {
        return try performRequest(chain.request as URLRequest)
    }

// MARK: - Private Functions

    fileprivate func performRequest(_ urlRequest: URLRequest) throws -> HttpResponse
    {
        var httpResponse: HttpResponse!
        var httpError: Error?

        // Create session configuration
        let config = URLSessionConfiguration.ephemeral

        config.httpAdditionalHeaders = [:]
        config.httpCookieStorage = (self.options.cookieStore as? HTTPCookieStorage)
        config.timeoutIntervalForResource = self.options.connectionTimeout
        config.timeoutIntervalForRequest  = self.options.requestTimeout

        // Send POST request using NSURLSession
        // @link http://stackoverflow.com/a/19101084

        // How to POST NSMutableURLRequest alogn with custome header fields using Alamofire
        // @link http://stackoverflow.com/q/27025811

        // How to use Alamofire with custom headers
        // @link http://stackoverflow.com/a/26055667

        // Create manager
        let manager = SessionManager(configuration: config)
        manager.startRequestsImmediately = false

        // Create suspended request
        let request = manager.request(urlRequest)

        if let sessionDelegate = request.session.delegate as? SessionDelegate
        {
            // Handle authentication challenge
            sessionDelegate.sessionDidReceiveChallenge = { session, challenge in
                return (.performDefaultHandling, nil)
            }
            sessionDelegate.taskDidReceiveChallenge = { session, task, challenge in
                return (.performDefaultHandling, nil)
            }

            // Handle redirects
            sessionDelegate.taskWillPerformHTTPRedirection = { session, task, response, request in
                // iOS 8.1 uses "Content-Type" header from original request after redirect that may leads to 415 Unsupported Media Type error
                // HACK: Remove "Content-Type" header from new request
                var mutableRequest = request
                mutableRequest.setValue("", forHTTPHeaderField: HttpHeaders.Header.ContentType)

                httpResponse = HttpResponse(response: response, redirectRequest: mutableRequest)

                // Refuse all redirects
                return nil
            }
        }

        // Request data from the server
        request.resume()

        // Add queue for getting of response
        let queue = DispatchQueue.global(qos: .default)

        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)

        // Handle response
        request.response(queue: queue) { (dataResponse) in
            if let redirectHttpResponse = httpResponse
            {
                // Append body to response
                httpResponse = redirectHttpResponse.copy(body: dataResponse.data)
            }
            else {
            // Handle request errors
            if let error = dataResponse.error
            {
                httpError = error
            }
            else
                // Handle HTTP response
                if let response = dataResponse.response
                {
                    httpResponse = HttpResponse(response: response, body: dataResponse.data)
                }
                else {
                    Roxie.fatalError("(response == nil) && (error == nil)")
                }
            }

            // Release a waiting thread
            semaphore.signal()
        }

        // Waiting for response
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        // Throw HTTP error if needed
        if let httpError = httpError {
            throw httpError
        }

        // Done
        return httpResponse
    }

// MARK: - Inner Types

    fileprivate struct Options
    {
        fileprivate var cookieStore: HttpCookieStore?
        fileprivate var connectionTimeout = NetworkConfig.Timeout.Connection
        fileprivate var requestTimeout = NetworkConfig.Timeout.Request
    }

// MARK: - Variables

    fileprivate let options: Options

}

// ----------------------------------------------------------------------------

class CallServerInterceptorBuilder
{
// MARK: - Functions

    func cookieStore(_ cookieStore: HttpCookieStore?) -> Self
    {
        self.options.cookieStore = cookieStore
        return self
    }

    func connectTimeout(_ timeout: TimeInterval) -> Self
    {
        Guard.greaterThanOrEqualTo(timeout, 0, "timeout < 0")
        self.options.connectionTimeout = timeout
        return self
    }

    func requestTimeout(_ timeout: TimeInterval) -> Self
    {
        Guard.greaterThanOrEqualTo(timeout, 0, "timeout < 0")
        self.options.requestTimeout = timeout
        return self
    }

    func build() -> CallServerInterceptor {
        return CallServerInterceptor(builder: self)
    }

// MARK: - Variables

    fileprivate var options = CallServerInterceptor.Options()

}

// ----------------------------------------------------------------------------

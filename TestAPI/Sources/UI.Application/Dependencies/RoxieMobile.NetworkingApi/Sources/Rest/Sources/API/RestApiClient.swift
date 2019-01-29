// ----------------------------------------------------------------------------
//
//  RestApiClient.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Alamofire
import Foundation
//import NetworkingApiHttp
////import SwiftCommonsDiagnostics
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

public final class RestApiClient
{
// MARK: - Construction

    fileprivate init(builder: RestApiClientBuilder)
    {
        // Init instance variables
        self.options = builder.options
    }

// MARK: - Functions

    public func get(_ entity: RequestEntity<HttpBody>) -> HttpResult {
        return execute(.get, entity: entity)
    }

    public func post(_ entity: RequestEntity<HttpBody>) -> HttpResult {
        return execute(.post, entity: entity)
    }

    public func put(_ entity: RequestEntity<HttpBody>) -> HttpResult {
        return execute(.put, entity: entity)
    }

    public func patch(_ entity: RequestEntity<HttpBody>) -> HttpResult {
        return execute(.patch, entity: entity)
    }

    public func delete(_ entity: RequestEntity<HttpBody>) -> HttpResult {
        return execute(.delete, entity: entity)
    }

    public func head(_ entity: RequestEntity<HttpBody>) -> HttpResult {
        return execute(.head, entity: entity)
    }

    public func options(_ entity: RequestEntity<HttpBody>) -> HttpResult {
        return execute(.options, entity: entity)
    }

// MARK: - Private Functions

    fileprivate func execute(_ method: HTTPMethod, entity: RequestEntity<HttpBody>) -> HttpResult
    {
        let result: HttpResult
        let cookieStore = BasicHttpCookieStore(cookies: entity.cookies)

        // Create HTTP request
        let urlRequest = newRequest(method, entity: entity)

        do {
            // Execute HTTP request
            var response = try executeWithAllInterceptors(urlRequest, cookieStore: cookieStore)

            // Follow up redirects
            while let redirectRequest = response.redirectRequest {
                response = try executeWithNetworkInterceptors(redirectRequest, cookieStore: cookieStore)
            }

            // Handle response
            result = HttpResult.success(handleHttpResponse(response, cookieStore))
        }
        catch let error as HttpResponseError
        {
            // Handle interrupted HTTP requests
            result = HttpResult.success(handleHttpResponse(error.httpResponse, cookieStore))
        }
        catch let error
        {
            // Handle any other errors
            result = HttpResult.failure(error)
        }

        // Done
        return result
    }

    fileprivate func executeWithAllInterceptors(_ urlRequest: URLRequest, cookieStore: HttpCookieStore) throws -> HttpResponse
    {
        var interceptors: [Interceptor] = []

        interceptors.append(contentsOf: self.options.interceptors)
        interceptors.append(contentsOf: self.options.networkInterceptors)
        interceptors.append(newCallServerInterceptor(cookieStore))

        return try execute(urlRequest, withInterceptors: interceptors, cookieStore: cookieStore)
    }

    fileprivate func executeWithNetworkInterceptors(_ urlRequest: URLRequest, cookieStore: HttpCookieStore) throws -> HttpResponse
    {
        var interceptors: [Interceptor] = []

        interceptors.append(contentsOf: self.options.networkInterceptors)
        interceptors.append(newCallServerInterceptor(cookieStore))

        return try execute(urlRequest, withInterceptors: interceptors, cookieStore: cookieStore)
    }

    fileprivate func execute(_ urlRequest: URLRequest, withInterceptors interceptors: [Interceptor], cookieStore: HttpCookieStore) throws -> HttpResponse
    {
        // Create first chain element
        let chain = InterceptorChain(interceptors: interceptors, index: 0, request: urlRequest)

        // Start executing interceptors chain
        return try chain.proceed(urlRequest)
    }

    fileprivate func newCallServerInterceptor(_ cookieStore: HttpCookieStore) -> CallServerInterceptor
    {
        return CallServerInterceptorBuilder()
                .cookieStore(cookieStore)
                .connectTimeout(self.options.connectionTimeout)
                .requestTimeout(self.options.requestTimeout)
                .build()
    }

    fileprivate func newRequest(_ method: HTTPMethod, entity: RequestEntity<HttpBody>) -> URLRequest
    {
        // Build HTTP request
        var request = URLRequestForMethod(method, entity.url!, headers: entity.headers?.allHeaderFields)

        // Create HTTP request body
        if let entityBody = entity.body
        {
            request.httpBody = entityBody.body
            request.setValue(entityBody.mediaType?.description, forHTTPHeaderField: HttpHeaders.Header.ContentType)
        }

        // Done
        return request
    }

    fileprivate func handleHttpResponse(_ httpResponse: HttpResponse, _ cookieStore: HttpCookieStore) -> ResponseEntity<Data>
    {
        var statusCode = HttpStatus.InternalServerError
        var headers = [String: String]()

        // Get HTTP headers
        for (key, value) in httpResponse.response.allHeaderFields {
            if let key = key as? String, let value = value as? String {
                headers[key] = value
            }
        }

        // Get status code
        if let httpStatus = HttpStatus.valueOf(httpResponse.response.statusCode) {
            statusCode = httpStatus
        }

        // Create response entity
        let httpHeaders = HttpHeaders(headers)
        let entityBuilder = BasicResponseEntityBuilder<Data>()
                .url(httpResponse.response.url)
                .headers(httpHeaders)
                .status(statusCode)
                // @see https://tools.ietf.org/html/rfc7231#section-3.1.1.5
                .mediaType(MediaType.ApplicationOctetStream)
                .cookies(cookieStore.cookies)

        if let responseBody = httpResponse.body {
            entityBuilder.body(responseBody)

            if let contentType = httpHeaders.contentType {
                entityBuilder.mediaType(contentType)
            }
        }

        // Done
        return entityBuilder.build()
    }

    fileprivate func URLRequestForMethod(_ method: HTTPMethod, _ URLString: URLConvertible, headers: [String: String]? = nil) -> URLRequest
    {
        guard let url = try? URLString.asURL() else { Roxie.fatalError("Unexpected URLString") }
        var mutableURLRequest = URLRequest(url: url)

        mutableURLRequest.httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }

        return mutableURLRequest
    }

// MARK: - Inner Types

    fileprivate struct Options
    {
        fileprivate var connectionTimeout = NetworkConfig.Timeout.Connection
        fileprivate var requestTimeout = NetworkConfig.Timeout.Request

        fileprivate var interceptors: [Interceptor] = []
        fileprivate var networkInterceptors: [Interceptor] = []
    }

// MARK: - Variables

    fileprivate let options: Options

}

// ----------------------------------------------------------------------------

open class RestApiClientBuilder
{
// MARK: - Functions

    open func connectTimeout(_ timeout: TimeInterval) -> Self
    {
        Guard.greaterThanOrEqualTo(timeout, 0, "timeout < 0")
        self.options.connectionTimeout = timeout
        return self
    }

    open func requestTimeout(_ timeout: TimeInterval) -> Self
    {
        Guard.greaterThanOrEqualTo(timeout, 0, "timeout < 0")
        self.options.requestTimeout = timeout
        return self
    }

    open func interceptors(_ interceptors: [Interceptor]) -> Self
    {
        self.options.interceptors = interceptors
        return self
    }

    open func networkInterceptors(_ networkInterceptors: [Interceptor]) -> Self
    {
        self.options.networkInterceptors = networkInterceptors
        return self
    }

    open func build() -> RestApiClient {
        return RestApiClient(builder: self)
    }

// MARK: - Variables

    fileprivate var options = RestApiClient.Options()

}

// ----------------------------------------------------------------------------

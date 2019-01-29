// ----------------------------------------------------------------------------
//
//  BasicRequestEntity.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHttp

// ----------------------------------------------------------------------------

open class BasicRequestEntity<T>: RequestEntity<T>
{
// MARK: - Construction

    init(builder: BasicRequestEntityBuilder<T>)
    {
        // Parent processing
        super.init(
            url: builder.url,
            headers: builder.headers,
            cookies: builder.cookies,
            body: builder.body
        )
    }

}

// ----------------------------------------------------------------------------

open class BasicRequestEntityBuilder<T>
{
// MARK: - Construction

    public init() {
        // Do nothing
    }

    public init(entity: RequestEntity<T>)
    {
        // Init instance variables
        self.url = entity.url
        self.headers = entity.headers
        self.cookies = entity.cookies
        self.body = entity.body
    }

    public init<Ti>(entity: RequestEntity<Ti>, body: T?)
    {
        // Init instance variables
        self.url = entity.url
        self.headers = entity.headers
        self.cookies = entity.cookies
        self.body = body
    }

// MARK: - Properties

    fileprivate(set) var url: URL?

    fileprivate(set) var headers: HttpHeaders?

    fileprivate(set) var cookies: [HttpCookieProtocol]?

    fileprivate(set) var body: T?

// MARK: - Functions

    @discardableResult open func url(_ url: URL?) -> Self {
        self.url = url
        return self
    }

    @discardableResult open func headers(_ headers: HttpHeaders?) -> Self {
        self.headers = headers
        return self
    }

    @discardableResult open func cookies(_ cookies: [HttpCookieProtocol]?) -> Self {
        self.cookies = cookies
        return self
    }

    @discardableResult open func body(_ body: T?) -> Self {
        self.body = body
        return self
    }

    open func build() -> BasicRequestEntity<T> {
        return BasicRequestEntity(builder: self)
    }

}

// ----------------------------------------------------------------------------

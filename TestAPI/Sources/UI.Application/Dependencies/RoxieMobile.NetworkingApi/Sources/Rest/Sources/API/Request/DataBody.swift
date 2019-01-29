// ----------------------------------------------------------------------------
//
//  DataBody.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHttp

// ----------------------------------------------------------------------------

open class DataBody: HttpBody
{
// MARK: - Construction

    fileprivate init(builder: DataBodyBuilder)
    {
        // Init instance variables
        self.mediaType = builder.mediaType
        self.body = builder.body
    }

// MARK: - Properties

    public let mediaType: MediaType?

    public let body: Data?

}

// ----------------------------------------------------------------------------

open class DataBodyBuilder
{
// MARK: - Construction

    public init() {
        // Do nothing
    }

// MARK: - Properties

    open fileprivate(set) var mediaType: MediaType?

    open fileprivate(set) var body: Data?

// MARK: - Functions

    open func mediaType(_ mediaType: MediaType?) -> Self
    {
        self.mediaType = mediaType
        return self
    }

    open func body(_ body: Data?) -> Self
    {
        self.body = body
        return self
    }

    open func build() -> DataBody {
        return DataBody(builder: self)
    }

}

// ----------------------------------------------------------------------------

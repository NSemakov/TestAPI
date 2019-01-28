// ----------------------------------------------------------------------------
//
//  AbstractNestedError.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHttp
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

open class AbstractNestedError: NestedError, AbstractClass
{
// MARK: - Construction

    public convenience init(entity: ResponseEntity<Data>) {
        self.init(entity: entity, cause: nil)
    }

    public init(entity: ResponseEntity<Data>, cause: Error?)
    {
        // Init instance variables
        self.entity = entity
        self.cause = cause
    }

// MARK: - Properties

    public let entity: ResponseEntity<Data>

    public let cause: Error?

}

// ----------------------------------------------------------------------------

extension AbstractNestedError: ResponseEntityHolder
{
// MARK: - Methods

    public func getResponseEntity() -> ResponseEntity<Data> {
        return self.entity
    }

    public func getResponseBodyAsBytes() -> Data? {
        return self.entity.body
    }

    public func getResponseBodyAsString() -> String? {
        var result: String?

        // Convert raw data to string
        if let body = self.entity.body, body.isNotEmpty {
            let charsetName = self.entity.headers?.contentType?.charset ?? Charset.forName("UTF8")
            if let encoding = EncodingProvider.encodingForCharset(charsetName) {
                result = String(data: body, encoding: encoding)
            }
        }

        return result
    }
}

// ----------------------------------------------------------------------------

extension AbstractNestedError
{
// MARK: - Properties

    public var description: String
    {
        var result = Roxie.typeName(of: self)

        if let cause = self.cause {
            result += "\nCaused by error: " + String(describing: cause).trim()
        }

        if let responseBody = getResponseBodyAsString() {
            result += "\nResponse body: \(responseBody)"
        }

        return result
    }

}

// ----------------------------------------------------------------------------

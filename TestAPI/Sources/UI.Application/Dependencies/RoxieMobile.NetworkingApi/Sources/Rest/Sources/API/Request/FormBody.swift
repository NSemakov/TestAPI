// ----------------------------------------------------------------------------
//
//  FormBody.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Alamofire
import Foundation
//import NetworkingApiHttp

// ----------------------------------------------------------------------------

open class FormBody: HttpBody
{
// MARK: - Construction

    fileprivate init(builder: FormBodyBuilder)
    {
        // Init instance variables
        self.formBody = builder.toData()
    }

// MARK: - Properties

    open var mediaType: MediaType? {
        return MediaType.ApplicationFormUrlencoded
    }

    open var body: Data? {
        return self.formBody
    }

// MARK: - Variables

    fileprivate let formBody: Data?

}

// ----------------------------------------------------------------------------

open class FormBodyBuilder
{
// MARK: - Construction

    public init() {
        // Do nothing
    }

// MARK: - Functions

    open func add(_ name: String, value: String) -> Self
    {
        self.values[name.trim()] = value.trim()
        return self
    }

    open func build() -> FormBody {
        return FormBody(builder: self)
    }

// MARK: - Private Functions

    fileprivate func toData() -> Data?
    {
        let values = self.values.filter{ !($0.0.isEmpty) }

        // Build form url encoded string
        let components = values.map{ key, value -> String in
            // Escape parameters
            let key = URLEncoding().escape(key)
            let value = URLEncoding().escape(value)

            // Build string
            return "\(key)=\(value)"
        }

        // Join components
        let stringBody = components.joined(separator: "&")

        // Build bytes array
        return stringBody.data(using: String.Encoding.utf8)
    }

// MARK: - Variables

    fileprivate var values: [String: String] = [:]
}

// ----------------------------------------------------------------------------

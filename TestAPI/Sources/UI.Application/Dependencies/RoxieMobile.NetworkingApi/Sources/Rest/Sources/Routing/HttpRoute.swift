// ----------------------------------------------------------------------------
//
//  HttpRoute.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Alamofire
import Foundation
////import NetworkingApiHelpers
//import NetworkingApiHttp
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

public final class HttpRoute
{
// MARK: - Construction

    fileprivate init(url: URL)
    {
        // Init instance variables
        self.url = url
    }

// MARK: - Properties

    public let url: URL

// MARK: - Functions

    public static func buildRoute(_ baseURL: URL, path: String? = nil, params: QueryParams? = nil) -> HttpRoute
    {
        // Build new URL
        var urlString = (baseURL.absoluteString)

        // Append path to URL
        if let path = path {
            urlString += path.trim()
        }

        // Append query params to URL
        if let params = params, !(params.isEmpty) {
            urlString += "?" + buildQueryString(params)
        }

        // Build new HTTP route
        var route: HttpRoute!
        if let url = URL(string: urlString) {
            route = HttpRoute(url: url)
        }

        // Validate result
        if (route == nil)
        {
            var message = "Could not create HTTP route"

            if let path = path {
                message += " for path ‘\(path)’"
            }

            message += "."

            Roxie.fatalError(message)
        }
        
        // Done
        return route
    }

// MARK: - Private Functions

    fileprivate static func buildQueryString(_ params: QueryParams) -> String
    {
        var components: [String] = []

        for (key, values) in params.items {
            components.append(contentsOf: buildQueryStringComponents(key, values: values))
        }

        // Done
        return components.joined(separator: "&")
    }

    fileprivate static func buildQueryStringComponents(_ key: String, values: [String]) -> [String]
    {
        if values.isEmpty { Roxie.fatalError("") }

        var components: [String] = []
        var encodedValue: String

        if (values.count > 1) {
            for value in values {
                encodedValue = URLEncoding().escape(key) + "[]=" + URLEncoding().escape(value)
                components.append(encodedValue)
            }
        }
        else {
            encodedValue = URLEncoding().escape(key) + "=" + URLEncoding().escape(values[0])
            components.append(encodedValue)
        }

        // Done
        return components
    }

}

// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
//
//  LogUtils.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import NetworkingApiHttp
////import SwiftCommonsLang
//import SwiftCommonsLogging

// ----------------------------------------------------------------------------

public final class LogUtils: NonCreatable
{
// MARK: - Functions

    public static func log(_ type: Any.Type, request: URLRequest, file: StaticString = #file, line: UInt = #line)
    {
        guard Logger.isLoggable(.debug) else { return }

        let hashString = String(format:"%08lx", request.hashValue)

        // Log URL
        let url = (request.url?.absoluteString ?? "")
        let method = (request.httpMethod ?? "")
        Logger.d(type, String(format: "[%d/rqst-url] %@ %@", hashString, method, url), file: file, line: line)

        // Log Headers
        Logger.d(type, String(format: "[%p/rqst-headers] %@", hashString, request.allHTTPHeaderFields ?? [:]), file: file, line: line)

        // Log Body
        if let body = String(data: (request.httpBody ?? Data()), encoding: String.Encoding.utf8) {
            Logger.d(type, String(format: "[%p/rqst-body] %@", hashString, body), file: file, line: line)
        }
    }

    public static func log(_ type: Any.Type, response: HTTPURLResponse, body: Data?, file: StaticString = #file, line: UInt = #line)
    {
        guard Logger.isLoggable(.debug) else { return }

        let hashString = String(format:"%08lx", response.hashValue)

        // Log Status
        if let status = HttpStatus.valueOf(response.statusCode) {
            Logger.d(type, String(format: "[%p/resp-status] %d %@", hashString, status.code.rawValue, status.reasonPhrase), file: file, line: line)
        }
        else {
            Logger.d(type, String(format: "[%p/resp-status] %d", hashString, response.statusCode), file: file, line: line)
        }

        // Log Headers
        Logger.d(type, String(format: "[%p/resp-headers] %@", hashString, response.allHeaderFields), file: file, line: line)

        // Log Body
        if let body = String(data: (body ?? Data()), encoding: String.Encoding.utf8) {
            Logger.d(type, String(format: "[%p/resp-body] %@", response, body), file: file, line: line)
        }
    }
}

// ----------------------------------------------------------------------------

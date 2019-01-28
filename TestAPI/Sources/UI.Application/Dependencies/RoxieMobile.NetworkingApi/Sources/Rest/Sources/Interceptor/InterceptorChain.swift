// ----------------------------------------------------------------------------
//
//  InterceptorChain.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
//import SwiftCommonsLang

// ----------------------------------------------------------------------------

open class InterceptorChain
{
// MARK: - Construction

    init(interceptors: [Interceptor], index: Int, request: URLRequest)
    {
        // Init instance variables
        self.interceptors = interceptors
        self.index = index
        self.request = request
    }

// MARK: - Properties

    public let request: URLRequest

// MARK: - Functions

    open func proceed(_ request: URLRequest) throws -> HttpResponse
    {
        guard (self.index < self.interceptors.count) else {
            Roxie.fatalError("Invalid intercepter index in chain.")
        }

        let next = InterceptorChain(interceptors: self.interceptors, index: (self.index + 1), request: request)

        let interceptor = self.interceptors[self.index]
        let result = try interceptor.intercept(next)

        return result
    }

// MARK: - Variables

    fileprivate let interceptors: [Interceptor]

    fileprivate let index: Int

}

// ----------------------------------------------------------------------------
